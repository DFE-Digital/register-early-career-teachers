TERRAFILE_VERSION=0.8
ARM_TEMPLATE_TAG=1.1.6
RG_TAGS={"Product" : "Early Careers Framework"}
REGION=UK South
SERVICE_NAME=ec2
SERVICE_SHORT=cpdec2
DOCKER_REPOSITORY=ghcr.io/dfe-digital/ecf2

watch-documentation-site:
	ls documentation/site/content/**/* | entr -s "cd documentation/site && bundle exec nanoc"

serve-documentation-site:
	cd documentation/site && bundle exec nanoc live --handler webrick --port 8000

build-documentation-site:
	cd documentation/site && bundle exec nanoc

help:
	@grep -E '^[a-zA-Z\._\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-compose-build:
	docker-compose build --build-arg BUNDLE_FLAGS='--jobs=4 --no-binstubs --no-cache' --parallel

.PHONY: review
review: test-cluster ## Specify review AKS environment
	$(if ${PULL_REQUEST_NUMBER},,$(error Missing PULL_REQUEST_NUMBER))
	$(eval ENVIRONMENT=review-${PULL_REQUEST_NUMBER})
	$(eval export TF_VAR_environment=${ENVIRONMENT})
	$(eval include config/global_config/review.sh)

.PHONY: staging
staging: test-cluster
	$(eval include config/global_config/staging.sh)

migration: production-cluster
	$(eval include config/global_config/migration.sh)

composed-variables:
	$(eval RESOURCE_GROUP_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-rg)
	$(eval KEYVAULT_NAMES='("${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv", "${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-inf-kv")')
	$(eval STORAGE_ACCOUNT_NAME=${AZURE_RESOURCE_PREFIX}${SERVICE_SHORT}${CONFIG_SHORT}tfsa)
	$(eval LOG_ANALYTICS_WORKSPACE_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-log)

ci:
	$(eval AUTO_APPROVE=-auto-approve)
	$(eval SKIP_AZURE_LOGIN=true)
	$(eval SKIP_CONFIRM=true)

bin/terrafile: ## Install terrafile to manage terraform modules
	curl -sL https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION}/terrafile_${TERRAFILE_VERSION}_$$(uname)_x86_64.tar.gz \
		| tar xz -C ./bin terrafile

set-azure-account:
	[ "${SKIP_AZURE_LOGIN}" != "true" ] && az account set -s ${AZURE_SUBSCRIPTION} || true

terraform-init: composed-variables bin/terrafile set-azure-account
	$(if ${DOCKER_IMAGE_TAG}, , $(eval DOCKER_IMAGE_TAG=main))

	./bin/terrafile -p config/terraform/application/vendor/modules -f config/terraform/application/config/$(CONFIG)_Terrafile
	terraform -chdir=config/terraform/application init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${ENVIRONMENT}_kubernetes.tfstate

	$(eval export TF_VAR_azure_resource_prefix=${AZURE_RESOURCE_PREFIX})
	$(eval export TF_VAR_config=${CONFIG})
	$(eval export TF_VAR_config_short=${CONFIG_SHORT})
	$(eval export TF_VAR_service_name=${SERVICE_NAME})
	$(eval export TF_VAR_service_short=${SERVICE_SHORT})
	$(eval export TF_VAR_docker_image=${DOCKER_REPOSITORY}:${DOCKER_IMAGE_TAG})

terraform-plan: terraform-init
	terraform -chdir=config/terraform/application plan -var-file "config/${CONFIG}.tfvars.json"

terraform-apply: terraform-init
	terraform -chdir=config/terraform/application apply -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

## DOCKER_IMAGE_TAG=fake-image make review terraform-unlock PULL_REQUEST_NUMBER=4169 LOCK_ID=123456
## DOCKER_IMAGE_TAG=fake-image make staging terraform-unlock LOCK_ID=123456
.PHONY: terraform-unlock
terraform-unlock: terraform-init
	terraform -chdir=config/terraform/application force-unlock ${LOCK_ID}

.PHONY: terraform-destroy
terraform-destroy: terraform-init
	terraform -chdir=config/terraform/application destroy -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

set-what-if:
	$(eval WHAT_IF=--what-if)

arm-deployment: composed-variables set-azure-account
	$(if ${DISABLE_KEYVAULTS},, $(eval KV_ARG=keyVaultNames=${KEYVAULT_NAMES}))
	$(if ${ENABLE_KV_DIAGNOSTICS}, $(eval KV_DIAG_ARG=enableDiagnostics=${ENABLE_KV_DIAGNOSTICS} logAnalyticsWorkspaceName=${LOG_ANALYTICS_WORKSPACE_NAME}),)

	az deployment sub create --name "resourcedeploy-tsc-$(shell date +%Y%m%d%H%M%S)" \
		-l "${REGION}" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_GROUP_NAME}" 'tags=${RG_TAGS}' \
		"tfStorageAccountName=${STORAGE_ACCOUNT_NAME}" "tfStorageContainerName=terraform-state" \
		${KV_ARG} \
		${KV_DIAG_ARG} \
		"enableKVPurgeProtection=${KV_PURGE_PROTECTION}" \
		${WHAT_IF}

deploy-arm-resources: arm-deployment ## Validate ARM resource deployment. Usage: make domains validate-arm-resources

validate-arm-resources: set-what-if arm-deployment ## Validate ARM resource deployment. Usage: make domains validate-arm-resources

test-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189t01-tsc-ts-rg)
	$(eval CLUSTER_NAME=s189t01-tsc-test-aks)

production-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189p01-tsc-pd-rg)
	$(eval CLUSTER_NAME=s189p01-tsc-production-aks)

get-cluster-credentials: set-azure-account
	az aks get-credentials --overwrite-existing -g ${CLUSTER_RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME}
	kubelogin convert-kubeconfig -l $(if ${GITHUB_ACTIONS},spn,azurecli)

set-namespace:
	$(eval NAMESPACE=$(shell jq -r '.namespace' "config/terraform/application/config/${CONFIG}.tfvars.json"))

aks-console: get-cluster-credentials set-namespace
	kubectl -n ${NAMESPACE} exec -ti --tty deployment/ec2-${ENVIRONMENT}-web -- /bin/sh -c "cd /app && bundle exec rails c"

aks-ssh: get-cluster-credentials set-namespace
	kubectl -n ${NAMESPACE} exec -ti --tty deployment/ec2-${ENVIRONMENT}-web -- /bin/sh

action-group-resources: set-azure-account # make env_aks action-group-resources ACTION_GROUP_EMAIL=notificationemail@domain.com . Must be run before setting enable_monitoring=true for each subscription
	$(if $(ACTION_GROUP_EMAIL), , $(error Please specify a notification email for the action group))
	echo ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg
	az group create -l uksouth -g ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg --tags "Product=Early Careers Framework" "Environment=Test" "Service Offering=Teacher services cloud"
	az monitor action-group create -n ${AZURE_RESOURCE_PREFIX}-ecf2 -g ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg --short-name ${AZURE_RESOURCE_PREFIX}-ecf2 --action email ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-email ${ACTION_GROUP_EMAIL}
