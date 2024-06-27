**Documenting service rules and why they exist**

*Created: May 2024*\
*Last updated: June 2024*

*This document currently covers the service rules for school / SIT and
Lead provider user tasks in the Manage training for ECTs, API &
guidance, and Manage CSV upload, as well as the AB and DP user tasks in
the Check data services.*

![](/media/image3.png){width="7.5in" height="5.66666447944007in"}

The service rules are tagged with the following key for why the rules
exist:

*🙋= user need*\
*📜= policy (explicit or intended)*\
*📚= contracts & funding*\
*💻= digital service*\
*📊= data*\
*🔒= security / GDPR*

# School user / admin / SIT

### **Request access to the Manage ECTs service via school GIAS email**

Context: For schools to use the Manage ECTs service, they first need to
register. This functionality is used both for schools who are using the
service for the first time as well as schools that can no longer access
the service via their existing SIT email (e.g. SIT has left).

+-----------------------------------------------------------------------+
| To register, the user must identify the school in our [GIAS register  |
| subset](https://github.com/DFE-Digital/earl                           |
| y-careers-framework/blob/main/app/models/concerns/gias_helpers.rb#L8) |
| using local authority (LA) and school name. The school must be open   |
| and either an eligible establishment type and/or in England. If       |
| school can't be found in the GIAS list, they can't request a link to  |
| access the service.                                                   |
|                                                                       |
| *📊 The GIAS register is used in order to check that the school is    |
| real. This is the most up to date list of schools available, with     |
| most of the details we need to check schools' eligibility to have     |
| ECTs serve induction.*                                                |
|                                                                       |
| *📜 School eligibility requirements for accessing the service come    |
| from the [statutory                                                   |
| guidance](https://github.c                                            |
| om/DFE-Digital/ecf2/blob/main/documentation/policy/induction-for-earl |
| y-career-teachers.adoc#institutions-in-which-induction-may-be-served) |
| which details the schools where ECTs can serve induction.*            |
+=======================================================================+
| School URN and address are shown for the user to confirm the correct  |
| school.                                                               |
|                                                                       |
| *📊 These are publicly available, unique school details to help the   |
| user confirm we have identified the correct school.*                  |
+-----------------------------------------------------------------------+
| GIAS email is shown in redacted form, including the first and last    |
| letter of the username and the full domain name (i.e.                 |
| <X****X@domain.com>).                                                 |
|                                                                       |
| *🙋* *Redacted email is shown to help schools identify where the GIAS |
| email has been sent.*                                                 |
|                                                                       |
| *🔒 The email is redacted because GIAS email is not publicly          |
| available information.*                                               |
+-----------------------------------------------------------------------+
| GIAS email can't be changed within the service - if the GIAS email is |
| incorrect/out of date, school needs to update it using [DfE sign      |
| in](https://services.signin.education.gov.uk/).                       |
|                                                                       |
| *📊 GIAS is the source of truth for the school email and* *can be     |
| updated via DfE Sign-in.*                                             |
+-----------------------------------------------------------------------+
| An email is sent to the school GIAS email on confirmation.            |
|                                                                       |
| *💻* *This is to confirm that the person trying to access the service |
| legitimately works at the selected school if they can (indirectly)    |
| access their school's GIAS email.*                                    |
|                                                                       |
| *📊 GIAS email is the most direct and up to date contact we have for  |
| schools (until SIT details are provided).*                            |
+-----------------------------------------------------------------------+
| Anyone can trigger the link being sent to a school's GIAS email and   |
| there is no limit on the number of times access can be requested.     |
|                                                                       |
| *💻 We don't know who specifically will need to access the service    |
| before we are told by the school and the current process means we     |
| don't / can't limit access for requesting the link to particular      |
| people. There is no specific need to limit the number of times access |
| can be requested.*                                                    |
+-----------------------------------------------------------------------+
| The link can be requested regardless of whether the school already    |
| has a SIT nominated or not.                                           |
|                                                                       |
| *🙋 This is to account for schools where the existing SIT account can |
| no longer be accessed (see [design                                    |
| history](https://teacher-cpd.desig                                    |
| n-history.education.gov.uk/manage-training/re-nomination-journey/)).* |
+-----------------------------------------------------------------------+

### **Nominate a school induction tutor (SIT)**

Context: Schools are asked to nominate an individual as the 'induction
tutor' who will oversee the induction and training process to ensure
that ECTs and their mentors are effectively supported and guided through
induction. Part of this role is to use the manage ECTs service to give
details of their school's mentors, ECTs and training option to DfE to
enable delivery and funding for ECTP training.

+-----------------------------------------------------------------------+
| Schools that say they are not expecting ECTs for the upcoming/current |
| (depending on when they access the service) academic year are not     |
| asked to nominate a SIT or use the service to report any further      |
| information.                                                          |
|                                                                       |
| *💻 The data collected in the Manage ECTs service is not applicable   |
| to schools that aren't expecting ECTs, so we don't need the school to |
| nominate a SIT user or sign into the service.*                        |
+=======================================================================+
| Schools that say they are expecting ECTs or are not sure yet must     |
| nominate a SIT.                                                       |
|                                                                       |
| *📜 This comes from the requirements in the [DfE                      |
| guidance](https://                                                    |
| www.gov.uk/guidance/how-to-set-up-training-for-early-career-teachers) |
| that it is a SIT responsibility to use the service.*                  |
+-----------------------------------------------------------------------+
| Only one SIT can be nominated per school.                             |
|                                                                       |
| *💻 UI for multiple user access is supported but not built. There is  |
| an assumption that only one person at the school will need to use the |
| service.*                                                             |
+-----------------------------------------------------------------------+
| Name and email address are provided to nominate the SIT.              |
|                                                                       |
| *💻 The email allows the nominated SIT to sign into the service. We   |
| also use their name and email as the contact for DfE comms.*          |
+-----------------------------------------------------------------------+
| There is a uniqueness validation on email address across all profiles |
| (SITs, ECTs and mentors). However, if both name and email address     |
| match an existing record, this person can be registered as the SIT    |
| for multiple schools.                                                 |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people. The combined name and email match is |
| to account for SIT who work across multiple schools (e.g. in a MAT).* |
+-----------------------------------------------------------------------+
| An email is sent to the nominated SIT on confirmation.                |
|                                                                       |
| *💻 The user nominating the SIT may not be the SIT themselves, so the |
| email notifies the nominated SIT and provides instructions for        |
| signing into the service.*                                            |
+-----------------------------------------------------------------------+
| Nominated SIT will be the email used for all further comms.           |
|                                                                       |
| *💻 Once nominated, the SIT becomes DfE's most direct point of        |
| contact with the school and is responsible for reporting ECTP         |
| training details.*                                                    |
+-----------------------------------------------------------------------+

### **Log in with an email address once nominated as SIT**

Context: Once nominated, the SIT becomes the school's user for the
Manage ECTs service and must log in to use the service and report ECTP
training details for their school.

+-----------------------------------------------------------------------+
| If user enters a registered email address on the sign in page, they   |
| are sent a magic sign in link via email which they can use to         |
| directly log into the service.                                        |
|                                                                       |
| *💻 Magic sign in link approach was deemed to be the best approach at |
| the time of original build.*                                          |
+=======================================================================+
| If the email address is not registered, the unregistered email is     |
| sent an email to explain next steps.                                  |
|                                                                       |
| *🙋 This email was created to reduce the number of support requests   |
| from people who couldn't remember if they had used the service before |
| or not, and people who couldn't remember which email was registered   |
| (see [design                                                          |
| hist                                                                  |
| ory](https://teacher-cpd.design-history.education.gov.uk/manage-train |
| ing/emailing-users-who-try-to-sign-in-with-an-unregistered-email/)).* |
+-----------------------------------------------------------------------+
| User must agree to privacy policy on first sign in.                   |
|                                                                       |
| *🔒 It is a GDPR requirement to inform users of how DfE will use      |
| their data.*                                                          |
+-----------------------------------------------------------------------+

### **Manage multiple schools with one email address**

Context: Some SITs may work across multiple schools (e.g. in a MAT), and
they can manage their multiple schools using the same email login for
the service.

+-----------------------------------------------------------------------+
| Multiple schools can nominate the same induction tutor if both name   |
| and email address match an existing record.                           |
|                                                                       |
| *💻 This is to account for SITs that may work across multiple schools |
| (e.g. in a MAT).*                                                     |
+=======================================================================+
| When signed into the service, the user can select between which of    |
| their schools they would like to manage. They can only manage a       |
| school one at a time.                                                 |
|                                                                       |
| *💻 The service was not built with this use case in mind.*            |
+-----------------------------------------------------------------------+

### **Change the SIT**

Context: Only one SIT user per school can use the service at a time, and
this person can be changed and replaced by someone ese at the school if
needed (e.g. if they leave the school, change role).

+-----------------------------------------------------------------------+
| User can change the nominated SIT and replace themselves with a       |
| different person by changing both nominated SIT name and email.       |
|                                                                       |
| *💻 This is to allow the SIT to be updated when there is a change in  |
| role or the existing SIT leaves.*                                     |
+=======================================================================+
| User can change their own registered email by entering the same name  |
| and changing the email only.                                          |
|                                                                       |
| *💻 There isn't an explicit journey built to change details of the    |
| existing SIT (existing functionality is used as a hack).*             |
+-----------------------------------------------------------------------+
| There is a uniqueness validation on email address across all SITs,    |
| ECTs and mentors. However, if both name and email address match an    |
| existing SIT record, this person can be registered as the SIT for     |
| multiple schools.                                                     |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people. The combined name and email match is |
| to account for SITs who work across multiple schools (e.g. in a       |
| MAT).*                                                                |
+-----------------------------------------------------------------------+
| User cannot change their own name whilst keeping their existing       |
| email.                                                                |
|                                                                       |
| *💻 There isn't an explicit journey built to change details of the    |
| existing SIT.*                                                        |
+-----------------------------------------------------------------------+
| When user changes SIT details, they immediately lose access to the    |
| SIT dashboard.                                                        |
|                                                                       |
| *💻 UI for multiple user access is supported but not built. There is  |
| an assumption that only one person at the school will need to use the |
| service.*                                                             |
+-----------------------------------------------------------------------+
| An email is sent to the new nominated SIT on confirmation.            |
|                                                                       |
| *💻 This email is to notify the new nominated SIT and provides        |
| instructions for signing into the service.*                           |
+-----------------------------------------------------------------------+
| New nominated SIT will be the email used for all further comms.       |
|                                                                       |
| *💻 Once nominated, the SIT becomes DfE's most direct point of        |
| contact with the school and is responsible for reporting ECTP         |
| training details.*                                                    |
+-----------------------------------------------------------------------+

### **Select and change the school induction programme**

Context: Each year, the SIT must report / confirm their 'default'
programme choice for the academic year.

+-----------------------------------------------------------------------+
| When registrations open, if user says they are expecting ECTs they    |
| must report a 'default' programme for the new academic year.          |
|                                                                       |
| *🙋 Most schools choose the same programme for all their ECTs in a    |
| particular year (with exceptions for things like transfers), so we    |
| ask schools to choose a 'default' which is used for any new ECTs      |
| rather than asking the user to select the same thing for each of      |
| their ECTs individually.*                                             |
+=======================================================================+
| If user chose FIP and had a partnership reported in the directly      |
| previous academic year, they are shown the names of the LP and DP     |
| they were working with and can rollover their previous programme and  |
| partnership choice.                                                   |
|                                                                       |
| *📜 The policy intent is for schools to continue with the FIP         |
| programme and the same LP/DP where possible.*                         |
+-----------------------------------------------------------------------+
| If user chose FIP in the previous academic year and LP/DP pairing has |
| changed, they must re-select programme choice for the new academic    |
| year.                                                                 |
|                                                                       |
| *📚 Some LP/DP contracts change year to year which means schools may  |
| not be able to continue working with the same pairing for the         |
| following year (see [design                                           |
| history](https://teacher-cpd.design-history.educati                   |
| on.gov.uk/manage-training/supporting-schools-in-lp-dp-transition/)).* |
+-----------------------------------------------------------------------+
| If user chose FIP but didn't have a partnership reported in the       |
| directly previous academic year, they must re-select programme choice |
| for the new academic year.                                            |
|                                                                       |
| *💻 There is no pairing to rollover.*                                 |
+-----------------------------------------------------------------------+
| LP is emailed if school is not able to automatically rollover their   |
| previous partnership due to a change in LP/DP pairing.                |
|                                                                       |
| *💻 If school reports that they're doing FIP again, the service       |
| treats it as a rejection of the partnership and triggers an email to  |
| the LP. This flags to the LP that if they are still working with the  |
| school with a new DP then they need to let us know which DP.*         |
+-----------------------------------------------------------------------+
| If user chose CIP, DIY, or didn't have a programme choice in the      |
| previous academic year, they must select programme choice for the new |
| academic year.                                                        |
|                                                                       |
| *🙋 The rollover mechanism was built for FIP as this was relevant to  |
| the majority of schools and helped speed up the registration journey  |
| for these schools. It was not an active choice to not let CIP and DIY |
| schools rollover.*                                                    |
+-----------------------------------------------------------------------+
| Once user has submitted their programme choice for an academic year,  |
| they must contact support to change the choice.                       |
|                                                                       |
| *💻 This was not a deliberate rule -- there is no strong policy       |
| reason. Note, LP can override the programme choice by reporting a     |
| partnership. As long as the school has a cohort set up for that year, |
| this sets the programme choice to FIP for that school.*               |
+-----------------------------------------------------------------------+
| If school is CIP only, they can only select CIP or DIY options.       |
|                                                                       |
| *📜 Only state-funded schools, colleges, sixth forms, children's      |
| centres and nurseries, maintained and non-maintained special schools, |
| and independent schools that receive Section 41 funding are not       |
| eligible for DfE funded training (see [DfE                            |
| guidance](https://                                                    |
| www.gov.uk/guidance/funding-and-eligibility-for-ecf-based-training)). |
| Other schools can access the service for CIP materials, or            |
| self-funded FIP.*                                                     |
+-----------------------------------------------------------------------+
| Once default programme choice is selected for an academic year, new   |
| ECTs and mentors in that year will be set to use this programme when  |
| registered.                                                           |
|                                                                       |
| *🙋 This is to reflect how things work on the ground -- the majority  |
| of schools with multiple ECTs will be doing the same programme.*      |
+-----------------------------------------------------------------------+

### 

### **Appoint and change Appropriate Body for a cohort or individual ECT**

Context: Schools must appoint an appropriate body (outside of the Manage
ECTs service) for their ECTs. We ask SITs to report their AB choice(s)
to DfE via the Manage ECTs service. Not a statutory need to report
within the service -- needs to be reported outside of the service. Use
the info to play the details back to the ABs -- to cross reference check
where schools have registered ECTs for training without registering for
induction. On their records they can also see the other way round --
might mean they've not filled in the AB or not registered the ECT at
all.

+-----------------------------------------------------------------------+
| SITs can report who they have appointed as their AB for an academic   |
| year, but they don't have to.                                         |
|                                                                       |
| *📜 Schools that will deliver any form of ECF-based training (FIP,    |
| CIP or DIY) must appoint an AB for each of their ECTs. Schools can    |
| choose whether to appoint one appropriate body for all of their ECTs, |
| or different ones.*                                                   |
|                                                                       |
| *📚 Schools **should** report to DfE who the AB is for each of their  |
| ECTs from a defined list of organisations that can act as an AB for   |
| each cohort. This is to enable ABs to cross check that ECTs have been |
| registered for both induction and training.*                          |
+=======================================================================+
| The list of ABs that can be appointed is updated each year. Some ABs  |
| can no longer be appointed going forwards or be used for existing     |
| cohorts / participants (see [2024                                     |
| changes](https://educationgovuk.sha                                   |
| repoint.com/:w:/r/sites/TeacherServices/Shared%20Documents/Teacher%20 |
| Continuing%20Professional%20Development/Teacher%20CPD%20Team/11.%20Pr |
| ovider%20Engagement%20%26%20Policy/ECF/2024%20cohort/AB%20list%20for% |
| 202024/AB%20changes%20to%20reflect%20before%202024%20registration%20o |
| pens.docx?d=w201a5f2247b541b3a401112eba53c099&csf=1&web=1&e=yrSkid)). |
|                                                                       |
| -   All schools can appoint a teaching school hub from the hardcoded  |
|     list in the service.                                              |
|                                                                       |
| -   Independent schools only can also appoint Independent Schools     |
|     Teacher Induction Panel (ISTIP).                                  |
|                                                                       |
| -   British schools overseas only can also appoint Educational        |
|     Success Partners (ESP).                                           |
|                                                                       |
| *📜 [DfE                                                              |
| guidance](https:/                                                     |
| /assets.publishing.service.gov.uk/media/661d459fac3dae9a53bd3de6/Appr |
| opriate_bodies_guidance_induction_and_the_early_career_framework.pdf) |
| sets out the organisations that can or cannot act as an AB. From      |
| September 2024, Teaching school hubs will become the main appropriate |
| body providers -- details can be found on                             |
| [gov.uk](https://www.gov.uk/guidance/teaching-school-hubs).* *We get  |
| the list for the service from policy -- there are 3 lists on gov.uk   |
| so policy give us the* *exact names.*                                 |
|                                                                       |
| *📊 Presenting only the eligible options to different types of        |
| schools in the service aims to improve data accuracy ([design         |
| history](https://teacher-cpd.design-history.education.gov.uk/manag    |
| e-training/improving-how-we-capture-appropriate-body-information/)).* |
+-----------------------------------------------------------------------+

### **View and challenge LP / DP partnership for an academic year**

Context: FIP schools choose a LP and DP to deliver training for their
ECTs. Once this agreement between the school and LP has been made
outside of the Manage ECTs service, LPs report this partnership via the
API.

+-----------------------------------------------------------------------+
| Nominated SIT email is used to log into the service. When user enters |
| the registered email into the service login page, an email is sent to |
| their email with a magic sign in link to sign into the service.       |
|                                                                       |
| *💻 Magic link approach was decided to be the best sign in option at  |
| the time.*                                                            |
+=======================================================================+
| When LP has reported a partnership with a school, LP and DP name are  |
| shown in the SIT dashboard.                                           |
|                                                                       |
| *📚 As schools do not report partnerships themselves, showing the     |
| partnership as reported by the LP allows schools to see if the        |
| details are as expected.*                                             |
|                                                                       |
| *💻 The provider reporting the partnership journey (rather than       |
| schools) was easier to build originally.*                             |
+-----------------------------------------------------------------------+
| Partnership can only be challenged during the first two weeks after   |
| it has been reported (if at another time of year), or in the first 3  |
| months of the academic year ([1st Sept -- 1st Dec?]{.mark}). This     |
| voids the partnership.                                                |
|                                                                       |
| *💻 This is to allow schools to correct provider errors. For example  |
| in some cases a provider can jump the gun and report a partnership    |
| when the school is actually speaking to multiple providers about      |
| forming a partnership still.*                                         |
|                                                                       |
| *💻 The challenge window is limited because schools can cause         |
| problems and impact declarations when they challenge a partnership.*  |
+-----------------------------------------------------------------------+
| There can only be one 'default' partnership for an academic year. LP  |
| can't claim a school if they already have a partnership -- school     |
| needs to challenge the existing partnership first.                    |
|                                                                       |
| *📚 Original assumption that everyone at a school would be doing the  |
| same thing -- exceptions added later (smaller numbers). Choices for   |
| each year are now less relevant -- we know schools' preference is to  |
| shift all participants, including those mid training, when a LP/DP    |
| pairing changes.*                                                     |
+-----------------------------------------------------------------------+
| After [X]{.mark}, LP / DP cannot be changed without contacting        |
| support.                                                              |
|                                                                       |
| *💻 The challenge window is limited because schools can cause         |
| problems and impact declarations when they challenge a partnership.*  |
+-----------------------------------------------------------------------+

### **Add an ECT**

Context: SITs are asked to register any new ECTs each year and provide
details to enable DfE to check their eligibility for funding and pass
details of ECTs to LPs to facilitate access to training.

+-----------------------------------------------------------------------+
| Schools must have selected a default programme choice for an academic |
| year to be able to add an ECT for that year.                          |
|                                                                       |
| *🙋 Most schools choose the same programme for all their ECTs in a    |
| particular year (with exceptions for things like transfers), so we    |
| ask schools to choose a 'default' which is used for any new ECTs      |
| rather than asking the user to select the same thing for each of      |
| their ECTs individually.*                                             |
+=======================================================================+
| Identify the teacher in TRA using their TRN and DOB and confirm the   |
| match by comparing their name. If there are no matches try            |
| re-matching with the inclusion of National Insurance Number.          |
|                                                                       |
| *📚 This is to enable DfE to check eligibility for funding (see       |
| section below).*                                                      |
|                                                                       |
| *🙋 SIT enters these details on behalf of ECTs as this caused         |
| confusion and delays when previously entered by the ECTs themselves   |
| (see [design                                                          |
| history](https://teacher-cpd.design                                   |
| -history.education.gov.uk/manage-training/validation-information/)).* |
+-----------------------------------------------------------------------+
| If we can identify the participant in TRA, we check first name        |
| matches. If name doesn't match, we ask if they are known by a         |
| different name until there is a match.                                |
|                                                                       |
| *📜 This is to enable real ECTs to register for training as part of   |
| statutory induction.*                                                 |
|                                                                       |
| *📚 This is to enable DfE to check* *eligibility for funding (see     |
| section below).*                                                      |
+-----------------------------------------------------------------------+
| If a teacher can't be found in the DQT, they cannot be added as an    |
| ECT.                                                                  |
|                                                                       |
| *💻 This prevents ECTs being added with incorrect details that may    |
| never be validated. This was previously allowed and required lots of  |
| manual checks.*                                                       |
+-----------------------------------------------------------------------+
| Name and email address is also provided when an ECT is added.         |
|                                                                       |
| *🙋 This is to pass the details onto the LPs for onboarding to their  |
| learning platform & invitations to training events. We also pass this |
| over for external evaluations (this is in the privacy policy).*       |
+-----------------------------------------------------------------------+
| There is a uniqueness validation on email addresses -- identities     |
| have a unique constraint and users have a unique constraint.          |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people.*                                     |
|                                                                       |
| *💻 Identity records were brought in to allow multiple emails and to  |
| help with deduping.*                                                  |
+-----------------------------------------------------------------------+
| If school has a default AB recorded, we ask SIT to confirm the ECT's  |
| AB. SIT can confirm the AB is the same as the default, or select a    |
| different AB.                                                         |
|                                                                       |
| -   SIT can select a teaching school hub from the hardcoded list in   |
|     the service                                                       |
|                                                                       |
| -   Independent schools only can also appoint ISTIP                   |
|                                                                       |
| -   British schools overseas only can also appoint ESP                |
|                                                                       |
| *📜 Schools that will deliver any form of ECF-based training (FIP,    |
| CIP or DIY) must appoint an AB for each of their ECTs. Schools can    |
| choose whether to appoint one appropriate body for all of their ECTs, |
| or different ones.*                                                   |
|                                                                       |
| *📚 Schools **should** report to DfE who the AB is for each of their  |
| ECTs from a defined list of organisations that can act as an AB for   |
| each cohort.*                                                         |
|                                                                       |
| *📜 [DfE                                                              |
| guidance](https:/                                                     |
| /assets.publishing.service.gov.uk/media/661d459fac3dae9a53bd3de6/Appr |
| opriate_bodies_guidance_induction_and_the_early_career_framework.pdf) |
| sets out the organisations that can or cannot act as an AB.* *We get  |
| the list for the service from policy -- there are 3 lists on gov.uk   |
| so policy give us the* *exact names.*                                 |
|                                                                       |
| *📊 Presenting only the eligible options to different types of        |
| schools in the service aims to improve data accuracy ([design         |
| history](https://teacher-cpd.design-history.education.gov.uk/manag    |
| e-training/improving-how-we-capture-appropriate-body-information/)).* |
+-----------------------------------------------------------------------+
| ECTs for an academic year can be added once registrations open for    |
| that academic year, and then anytime throughout the year afterwards.  |
|                                                                       |
| *📚 Participants must be added to a cohort, and can't be registered   |
| until that cohort is set up in the service, because they have to be   |
| associated with a contract / funding pot.*                            |
|                                                                       |
| *🙋 Schools may already know in summer which ECTs will be joining for |
| the following year, and then participants may join at any time        |
| throughout the academic year.*                                        |
+-----------------------------------------------------------------------+
| An email is sent to the participant informing them they've been       |
| registered.                                                           |
|                                                                       |
| *🙋 This was originally because ECTs had to enter information         |
| themselves but SITs now enter all the information on their behalf.*   |
|                                                                       |
| *🔒 This is to provide participants with the privacy policy, and set  |
| expectations about hearing from the provider.*                        |
+-----------------------------------------------------------------------+
| When the teacher is added, they're checked against the DQT for if     |
| they have QTS (or other relevant qualification) and an induction      |
| start date that has been provided from the appropriate body portal.   |
| ECTs can be added even if they don't yet have QTS, but they won\'t    |
| appear as eligible to LPs.                                            |
|                                                                       |
| *📚 QTS is used to confirm the ECT's eligibility for funding, and the |
| induction start date is used to confirm the correct cohort            |
| allocation.*                                                          |
|                                                                       |
| *🙋 School may want to register their incoming ECTs before they have  |
| finished their ITT.*                                                  |
+-----------------------------------------------------------------------+
| If a teacher is registered as a mentor in the service, they cannot be |
| added as an ECT.                                                      |
|                                                                       |
| *📜 DfE only fund one set of training at a time - this was agreed at  |
| ECF working group.*                                                   |
+-----------------------------------------------------------------------+
| If school has selected FIP or CIP but not added any mentors or ECTs,  |
| SIT is sent an email reminder.                                        |
|                                                                       |
| *💻 This is to ensure schools that are expecting ECTs have registered |
| their participants to enable access to training.*                     |
+-----------------------------------------------------------------------+

### **Transfer in an ECT**

Context: Some ECTs transfer schools during induction, which may also
involve changing their training option/LP/AB. We ask SITs to reflect
these changes in the Manage ECTs service to ensure the correct payments
are made.

+-----------------------------------------------------------------------+
| Schools must have selected a default programme choice for an academic |
| year to be able to transfer in an ECT for that year.                  |
|                                                                       |
| *🙋 Most schools choose the same programme for all their ECTs in a    |
| particular year (with exceptions for things like transfers), so we    |
| ask schools to choose a 'default' which is used for any new ECTs      |
| rather than asking the user to select the same thing for each of      |
| their ECTs individually.*                                             |
+=======================================================================+
| If ECT identified in TRA is already registered at another school in   |
| the service during ECT registration, user asked to confirm that they  |
| are transferring the ECT into their school.                           |
|                                                                       |
| *💻 This allows us to retain the ECT's participant profile so we know |
| what training they have completed, which is captured in the history   |
| of declarations received (see [design                                 |
| history                                                               |
| ](https://teacher-cpd.design-history.education.gov.uk/manage-training |
| /facilitating-participants-moving-schools-during-their-induction/)).* |
|                                                                       |
| *📚 This ensures we only pay providers what they are owed for the     |
| training they delivered to the participant based on the payment       |
| milestones.*                                                          |
+-----------------------------------------------------------------------+
| Specify date ECT will be transferring in, which can be in the past or |
| future.                                                               |
|                                                                       |
| *💻 This is used to trigger a change in status for the ECT in the SIT |
| dashboard. The date will also trigger the ECT to show as no longer    |
| training at the old school.*                                          |
+-----------------------------------------------------------------------+
| User can choose to continue with ECT's LP/DP from previous school or  |
| switch to new LP/DP (either the school's default LP or other).        |
|                                                                       |
| *📜 There is a policy preference / assumption that it's in ECTs best  |
| interest to continue with the same provider. This was previously a    |
| DfE recommendation, but now watered down and schools tend to have a   |
| stronger preference to have all their participants with the same      |
| provider, including transfers.*                                       |
+-----------------------------------------------------------------------+
| User can change ECT's email address as part of transfer in. In this   |
| case both email addresses are associated with the participant.        |
|                                                                       |
| *🙋 Participants usually get a new email address when they move to a  |
| new school. We need up to date emails because we pass this over for   |
| external evaluations (this is in the privacy policy) and give emails  |
| to LPs.*                                                              |
+-----------------------------------------------------------------------+
| If a teacher is registered as a mentor in the service, they cannot be |
| added as an ECT.                                                      |
|                                                                       |
| *📜 DfE only fund one set of training at a time - this was agreed at  |
| ECF working group.*                                                   |
+-----------------------------------------------------------------------+
| An email is sent to the participant informing them they've been       |
| registered.                                                           |
|                                                                       |
| *🔒 This is to provide participants with the privacy policy, and set  |
| expectations about hearing from the provider.*                        |
+-----------------------------------------------------------------------+
| LPs is emailed on reporting of transfer.                              |
|                                                                       |
| *🙋 Before API v3, it was more difficult to see the details around    |
| transfers, so provider emails were sent to notify them of transfers.  |
| These may no longer be needed now.*                                   |
+-----------------------------------------------------------------------+
| On the joining date, ECT is shown as 'left' at their previous school. |
|                                                                       |
| *💻 We assume that the ECT is no longer working at their previous     |
| school if a new school has claimed them. We don't support ECTs        |
| working across multiple schools.*                                     |
+-----------------------------------------------------------------------+
| On the joining date, ECT is unpaired from any mentor they were paired |
| with at previous school.                                              |
|                                                                       |
| *💻 We assume that the ECT will no longer be mentored by the mentor   |
| at their previous school, so remove the pairing.*                     |
+-----------------------------------------------------------------------+

### 

### **Change an existing ECT's details (from ECT profile)**

Context: SITs are able to change certain details of registered ECTs to
account for errors and genuine changes in details.

+-----------------------------------------------------------------------+
| User can change ECT name.                                             |
|                                                                       |
| -   SIT can change name if it's due to the ECT having changed their   |
|     name (marriage, divorce etc) or their name was entered            |
|     incorrectly. SIT blocked from changing name if they say the ECT   |
|     shouldn't have been registered or they want to replace them with  |
|     a different person.                                               |
|                                                                       |
| -   ECT must not have completed induction and must not have left the  |
|     school for the SIT to be able to change name. There is an option  |
|     to contact support if the ECT has completed or left.              |
|                                                                       |
| -   We allow changing the whole name.                                 |
|                                                                       |
| *🙋 ECT may have a name change or have an error in the entered name.* |
|                                                                       |
| *💻 We ask why an ECT's name needs changing because SITs were         |
| previously using this functionality as a 'hack' for replacing an      |
| existing ECT with a different person in the service.*                 |
|                                                                       |
| *💻 Allowing changing whole name creates a risk that users could      |
| still overwrite a record with a different person as we don't          |
| revalidate.*                                                          |
+=======================================================================+
| User can change ECT email.                                            |
|                                                                       |
| -   ECT must not have completed induction and must not have left the  |
|     school for the SIT to be able to change email. There is an option |
|     to contact support if the ECT has completed or left.              |
|                                                                       |
| -   There is a uniqueness validation on email addresses.              |
|                                                                       |
| *📚 ECT may have a change to their email address -- we need up to     |
| date emails because we pass this over for external evaluations (this  |
| is in the privacy policy) and give emails to LPs.*                    |
|                                                                       |
| *🙋 Some people might register with personal emails first because     |
| they don't have a school email yet, so need to change it later.*      |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people.*                                     |
+-----------------------------------------------------------------------+
| User can change AB.                                                   |
|                                                                       |
| -   ECT must not have completed induction and must not have left the  |
|     school for the SIT to be able to change AB.                       |
|                                                                       |
| -   SITs can add/change the AB for an individual ECT -- the AB for    |
|     individual can be the same or different to the default for their  |
|     cohort.                                                           |
|                                                                       |
| -   All schools can appoint a teaching school hub from the hardcoded  |
|     list in the service                                               |
|                                                                       |
| -   Independent schools only can also appoint ISTIP                   |
|                                                                       |
| -   British schools overseas only can also appoint ESP                |
|                                                                       |
| *🙋 This is to let users correct details where they may have          |
| initially entered the wrong one / struggled with the journey.*        |
|                                                                       |
| *📜 Schools that will deliver any form of ECF-based training (FIP,    |
| CIP or DIY) must appoint an AB for each of their ECTs. Schools can    |
| choose whether to appoint one appropriate body for all of their ECTs, |
| or different ones.*                                                   |
|                                                                       |
| *📜 [DfE                                                              |
| guidance](https:/                                                     |
| /assets.publishing.service.gov.uk/media/661d459fac3dae9a53bd3de6/Appr |
| opriate_bodies_guidance_induction_and_the_early_career_framework.pdf) |
| sets out the organisations that can or cannot act as an AB.* *We get  |
| the list for the service from policy -- there are 3 lists on gov.uk   |
| so policy give us the* *exact names.*                                 |
|                                                                       |
| *📚 Schools **should** report to DfE who the AB is for each of their  |
| ECTs from a defined list of organisations that can act as an AB for   |
| each cohort.*                                                         |
|                                                                       |
| *📊 Presenting only the eligible options to different types of        |
| schools in the service aims to improve data accuracy ([design         |
| history](https://teacher-cpd.design-history.education.gov.uk/manag    |
| e-training/improving-how-we-capture-appropriate-body-information/)).* |
+-----------------------------------------------------------------------+
| User cannot change TRN, DoB, or LP without contacting support.        |
|                                                                       |
| *💻 TRN and DOB are used to validate the participant, so the          |
| participant needs to be re-validated when changing these details. A   |
| way to re-validate participants automatically in the service hasn't   |
| been built so is done manually via support.*                          |
+-----------------------------------------------------------------------+

### **View ECT eligibility / training status**

Context: Registered ECTs are shown to SITs in the Manage ECTs service to
allow them to view details and manage any changes.

+-----------------------------------------------------------------------+
| View and filter ECTs who are currently training, completed induction  |
| and no longer training.                                               |
|                                                                       |
| *🙋 This is to allow users to easily find the ECTs their looking for  |
| (see [design                                                          |
| history](https://teacher-cpd.design-history                           |
| .education.gov.uk/manage-training/filtering-early-career-teachers/))* |
+=======================================================================+
| View ECT induction start date. We do not show ECT cohorts.            |
|                                                                       |
| *🙋 This is to allow users to easily see which stage an ECT is at     |
| without showing cohorts as this was found to be confusing (see        |
| [design                                                               |
| history](https://teacher-cpd.design-history.                          |
| education.gov.uk/manage-training/sorting-by-induction-start-date/)).* |
+-----------------------------------------------------------------------+

### 

### **Add a mentor**

Context: All ECTs must be assigned a mentor as part of their statutory
induction. Mentors must be registered and assigned in the Manage ECTs
service for schools to get funding for mentor time off timetable and to
provide mentors access to their ECT's materials. FIP mentors are also
entitled to mentor training and associated funding for schools and
providers.

+-----------------------------------------------------------------------+
| Schools must have selected a default programme choice for an academic |
| year to be able to add a mentor for that year.                        |
|                                                                       |
| *🙋 Most schools choose the same programme for all their participants |
| in a particular year (with exceptions for things like transfers), so  |
| we ask schools to choose a 'default' which is used for any new        |
| mentors rather than asking the user to select the same thing for each |
| of their mentors individually.*                                       |
+=======================================================================+
| Mentor must have a TRN to be registered. If mentor doesn't already    |
| have a TRN, they can request one outside the service:                 |
| <https://www.gov.uk/guidance/teacher-reference-number-trn>            |
|                                                                       |
| *📚 This is to enable DfE to check against TRA records that the       |
| mentor does not have any prohibitions, sanctions or restrictions on   |
| their record, and to check eligibility for funding (see section       |
| below).*                                                              |
+-----------------------------------------------------------------------+
| Identify the teacher in TRA using their TRN and DOB and confirm the   |
| match by comparing their name. If there are no matches try            |
| re-matching with the inclusion of National Insurance Number.          |
|                                                                       |
| *📚 This is to enable DfE to check against TRA records that the       |
| mentor does not have any prohibitions, sanctions or restrictions on   |
| their record, and to check eligibility for funding (see section       |
| below).*                                                              |
|                                                                       |
| *🙋 SIT enters these details on behalf of mentors as this caused      |
| confusion and delays when previously entered by the mentors           |
| themselves (see [design                                               |
| history](https://teacher-cpd.design                                   |
| -history.education.gov.uk/manage-training/validation-information/)).* |
+-----------------------------------------------------------------------+
| If a teacher can't be found in the DQT, they cannot be added as a     |
| mentor.                                                               |
|                                                                       |
| *📚 This is because we can't check against TRA records that the       |
| mentor does not have any prohibitions, sanctions or restrictions on   |
| their record, and we can't check eligibility for funding (see section |
| below).*                                                              |
+-----------------------------------------------------------------------+
| If we can identify the participant in TRA, we check first name        |
| matches. If name doesn't match, we ask if they are known by a         |
| different name until there is a match.                                |
|                                                                       |
| *📚 This is to enable DfE to check against TRA records that the       |
| mentor does not have any prohibitions, sanctions or restrictions on   |
| their record, and to check eligibility for funding (see section       |
| below).*                                                              |
+-----------------------------------------------------------------------+
| There is a uniqueness validation on email addresses.                  |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people.*                                     |
+-----------------------------------------------------------------------+
| A SIT can add themselves as a mentor using the same journey.          |
|                                                                       |
| *📜 [DfE                                                              |
| guidance](https://www.gov.uk/guidance/how-to-s                        |
| et-up-training-for-early-career-teachers#nominate-an-induction-tutor) |
| encourages schools to separate the roles of SIT and mentor, but they  |
| can still add themselves if needed (see [design                       |
| history](https://teacher-cpd.design-history.education.gov.uk/manage-t |
| raining/changing-how-induction-tutors-add-themselves-as-a-mentor/)).* |
+-----------------------------------------------------------------------+
| If school has a default provider recorded, we ask SIT to confirm the  |
| mentor\'s provider for mentor training.                               |
|                                                                       |
| *📚 [Triggered if school has more than one LP?]{.mark} In 2023 there  |
| were \~1100 cases where because the mentor was set to the default     |
| provider, they were training with a different provider to their ECT   |
| (where there were different providers for different cohorts). We had  |
| to check this was correct via providers.*                             |
+-----------------------------------------------------------------------+
| Mentors for an academic year can be added once registrations open for |
| that academic year, and then anytime throughout the year afterwards.  |
|                                                                       |
| *📚 Participants must be added to a cohort, and can't be registered   |
| until that cohort is set up in the service. This is so they can be    |
| associated with a contract / funding pot.*                            |
|                                                                       |
| *🙋 Schools may already know in summer who will be acting as a mentor |
| for the following year, and then new mentors may start mentoring at   |
| any time throughout the academic year.*                               |
+-----------------------------------------------------------------------+
| An email is sent to the participant informing them they've been       |
| registered. This isn't sent if the mentor is also a registered SIT.   |
|                                                                       |
| *🔒 This is to provide participants with the privacy policy, and set  |
| expectations about hearing from the provider.*                        |
+-----------------------------------------------------------------------+
| Mentor may or may not be doing mentor training.                       |
|                                                                       |
| *📜 FIP mentors can complete 2 years of funded mentor training.       |
| Mentors don't have to complete this training.*                        |
+-----------------------------------------------------------------------+

### **Transfer in a mentor**

Context: Some mentors transfer schools each year. We ask SITs to reflect
these changes in the Manage ECTs service to ensure the correct payments
are made.

+-----------------------------------------------------------------------+
| Schools must have selected a default programme choice for an academic |
| year to be able to transfer in a mentor for that year.                |
|                                                                       |
| *🙋 Most schools choose the same programme for all their participants |
| in a particular year (with exceptions for things like transfers), so  |
| we ask schools to choose a 'default' which is used for any new        |
| mentors rather than asking the user to select the same thing for each |
| of their mentors individually.*                                       |
+=======================================================================+
| If mentor identified in TRA is already registered at another school   |
| in the service during mentor registration, user is asked to confirm   |
| that they are transferring the mentor into their school.              |
|                                                                       |
| *💻 This allows us to retain the mentor's participant profile so we   |
| know what training they have completed, which is captured in the      |
| history of declarations received (see [design                         |
| history                                                               |
| ](https://teacher-cpd.design-history.education.gov.uk/manage-training |
| /facilitating-participants-moving-schools-during-their-induction/)).* |
|                                                                       |
| *📚 This ensures we only pay providers what they are owed for the     |
| training they delivered to the participant based on the payment       |
| milestones.*                                                          |
+-----------------------------------------------------------------------+
| Specify date mentor will be transferring in, which can be in the past |
| or future.                                                            |
|                                                                       |
| *💻 This is used to trigger a change in status for the mentor in the  |
| SIT dashboard.*                                                       |
+-----------------------------------------------------------------------+
| On the leaving date, mentorship links with ECTs at the previous       |
| school are removed and the mentor is no longer shown in the pool of   |
| mentors.                                                              |
|                                                                       |
| *💻 Unless the mentor is working across multiple schools, they are no |
| longer available to mentor ECTs at the school so are not shown in the |
| dashboard.*                                                           |
+-----------------------------------------------------------------------+
| User is asked if the mentor is mentoring across multiple schools. If  |
| yes, they must contact support to complete this. The mentor will show |
| in the list of mentors at both schools.                               |
|                                                                       |
| *💻 The service wasn't built to account for this use case.*           |
+-----------------------------------------------------------------------+
| User can choose to continue with mentor's LP/DP from previous school  |
| or switch to new LP/DP (either the school's default LP or other).     |
|                                                                       |
| *📜 Mentor can choose to continue mentor training without ECT.*       |
+-----------------------------------------------------------------------+
| User can change mentor's email address as part of transfer in.        |
|                                                                       |
| *🙋 Participants usually get a new email address when they move to a  |
| new school.*                                                          |
+-----------------------------------------------------------------------+
| An email is sent to the participant informing them they've been       |
| registered                                                            |
|                                                                       |
| *🔒 This is to provide participants with the privacy policy, and set  |
| expectations about hearing from the provider.*                        |
+-----------------------------------------------------------------------+
| [It might also email the provider (?)]{.mark}                         |
|                                                                       |
| *🙋 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+

### 

### **Change an existing mentor's details (from mentor profile)**

Context: SITs are able to change certain details of registered mentors
to account for errors and genuine changes in details.

+-----------------------------------------------------------------------+
| User can change mentor name.                                          |
|                                                                       |
| -   Mentor must not have left the school for the user to be able to   |
|     change their name. There is an option to contact support if the   |
|     mentor has left.                                                  |
|                                                                       |
| -   SIT can change name if it's due to the mentor having changed      |
|     their name (marriage, divorce etc) or their name was entered      |
|     incorrectly. SIT blocked from changing name if they say the       |
|     mentor shouldn't have been registered or they want to replace     |
|     them with a different person.                                     |
|                                                                       |
| -   We allow changing the whole name.                                 |
|                                                                       |
| *🙋 Mentor may have a name change or have an error in the entered     |
| name.*                                                                |
|                                                                       |
| *💻 We ask why an ECT's name needs changing because SITs were         |
| previously using this functionality as a 'hack' for replacing an      |
| existing ECT with a different person in the service.*                 |
|                                                                       |
| *💻 Allowing changing whole name creates a risk that users could      |
| still overwrite a record with a different person as we don't          |
| revalidate.*                                                          |
+=======================================================================+
| User can change mentor email.                                         |
|                                                                       |
| -   Mentor must not have left the school for the SIT to be able to    |
|     change email. There is an option to contact support if the mentor |
|     has left.                                                         |
|                                                                       |
| -   There is a uniqueness validation on email addresses.              |
|                                                                       |
| *📚 Mentor may have a change to their email address -- we need up to  |
| date emails because we pass this over for external evaluations (this  |
| is in the privacy policy) and give emails to LPs.*                    |
|                                                                       |
| *🙋 Some people might register with personal emails first because     |
| they don't have a school email yet, so need to change it later.*      |
|                                                                       |
| *💻 The uniqueness validation is to avoid the same email address      |
| being used for different people.*                                     |
+-----------------------------------------------------------------------+
| User cannot change TRN, DoB, or LP without contacting support.        |
|                                                                       |
| *💻 TRN and DOB are used to validate the participant, so the          |
| participant needs to be re-validated when changing these details. A   |
| way to re-validate participants automatically in the service hasn't   |
| been built so is done manually via support.*                          |
+-----------------------------------------------------------------------+

### 

### **View mentor mentoring status / training completion status**

Context: Registered mentors are shown to SITs in the Manage ECTs service
to allow them to view details and manage any changes.

+-----------------------------------------------------------------------+
| View mentors who are currently mentoring and not mentoring.           |
|                                                                       |
| *🙋 This is to allow users to more easily find the mentors their      |
| looking for.*                                                         |
+=======================================================================+
+-----------------------------------------------------------------------+

### **Create and change mentorship links between ECTs and mentors**

Context: All ECTs must be assigned a mentor to support them during their
induction.

+-----------------------------------------------------------------------+
| User can assign a mentor to an ECT in the ECT registration journey,   |
| the mentor registration journey or after an ECT and mentor are        |
| registered in the SIT dashboard.                                      |
|                                                                       |
| *📜 All ECTs must be assigned a mentor during their induction (see    |
| [statutory                                                            |
| guidance](https:/                                                     |
| /assets.publishing.service.gov.uk/media/6629237f3b0122a378a7e6ef/Indu |
| ction_for_early_career_teachers__England__statutory_guidance_.pdf)).* |
|                                                                       |
| *🙋 The design aims to encourage users to assign a mentor to any ECTs |
| who do not yet have one assigned (see [design                         |
| history](https://teacher-cpd.design-hi                                |
| story.education.gov.uk/manage-training/assigning-ects-to-mentors/)).* |
+=======================================================================+
| Mentor must be registered in the service in the same school as the    |
| ECT to be available as a mentor for an ECT. Note, mentors may be in   |
| the mentor pool at more than one school.                              |
|                                                                       |
| *💻 The service was built on the assumption that a mentor would       |
| always be at the same school as their assigned ECT.*                  |
+-----------------------------------------------------------------------+
| Any registered mentor at the same school can be assigned to any ECT   |
| who doesn't already have a mentor assigned. ECT can only be assigned  |
| one mentor at a time.                                                 |
|                                                                       |
| *📜 ECTs must have a dedicated mentor, but there is no limit on       |
| having other additional mentors.*                                     |
|                                                                       |
| *📚 DfE commercial decision not to pay for time off timetable for     |
| additional mentors.*                                                  |
+-----------------------------------------------------------------------+
| There is no limit on the number of ECTs a mentor can be assigned to.  |
|                                                                       |
| *📜 Whilst there is no specific limit, [DfE statutory                 |
| guidance](http                                                        |
| s://assets.publishing.service.gov.uk/media/6629237f3b0122a378a7e6ef/I |
| nduction_for_early_career_teachers__England__statutory_guidance_.pdf) |
| sets out that mentors should be able to support an ECT, and too many  |
| pairings would impact a mentor's capacity to do that.*                |
+-----------------------------------------------------------------------+
| Mentor may or may not be doing mentor training.                       |
|                                                                       |
| *📜 [Mentors can complete 2 years of funded mentor training. Mentors  |
| don't need to be in training or have completed training to be able to |
| mentor an ECT.]{.mark}*                                               |
+-----------------------------------------------------------------------+
| Assigned mentor for an ECT can be changed to a different registered   |
| mentor at any time, but cannot be removed.                            |
|                                                                       |
| *📜 [???]{.mark} We didn't build this option. Policy that every ECT   |
| must have a mentor*                                                   |
+-----------------------------------------------------------------------+
| User can change mentorship following the same rules above, and:       |
|                                                                       |
| -   ECT must not have completed induction and must not have left the  |
|     school for the SIT to be able to change mentor.                   |
|                                                                       |
| -   Mentor must not have left the school for the SIT to be able to    |
|     change the ECT they are assigned to or add others.                |
|                                                                       |
| *📜 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+

### 

### **Report ECT is transferring out**

Context: Schools can report that an ECT is leaving their school and
transferring to a different school. LPs can view this data via the API
but we otherwise do not use this data.

+-----------------------------------------------------------------------+
| User can report that an ECT is transferring to another school. This   |
| is not mandatory.                                                     |
|                                                                       |
| *🙋 This is to allow SITs to tidy their dashboard and move ECTs who   |
| are leaving / have left to a different section ("no longer training") |
| of their school's dashboard if they want to (see [design              |
| history                                                               |
| ](https://teacher-cpd.design-history.education.gov.uk/manage-training |
| /facilitating-participants-moving-schools-during-their-induction/)).* |
+=======================================================================+
| Specify leaving date, which can be in the past or future (no          |
| constraints?).                                                        |
|                                                                       |
| *💻 The leaving date triggers the move of that ECT in the SIT         |
| dashboard.*                                                           |
+-----------------------------------------------------------------------+
| [Email is sent to the ppt on confirmation?]{.mark}                    |
|                                                                       |
| *[🙋 ???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| ECT is shown in SIT dashboard as leaving or no longer being trained.  |
|                                                                       |
| *💻 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| Leaving date not shown in the service once it has been submitted, and |
| can't be changed.                                                     |
|                                                                       |
| *💻 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| ECT cannot be re-added once they have been reported as leaving / have |
| left.                                                                 |
|                                                                       |
| *💻 [??? Not built]{.mark}*                                           |
+-----------------------------------------------------------------------+
| User cannot report through the service if ECT is leaving for any      |
| reason other than transferring to another school.                     |
|                                                                       |
| *💻 [??? Moving school was most common option -- not built]{.mark}*   |
|                                                                       |
| *🙋 We do not yet have a clear understanding of user needs and pain   |
| points for this journey (see [design                                  |
| history](https://teacher-cpd.design-h                                 |
| istory.education.gov.uk/manage-training/teachers-leaving-schools/)).* |
+-----------------------------------------------------------------------+

### 

### **Report mentor is transferring out**

Context: Schools can report that a mentor is leaving their school and
transferring to a different school. LPs can view this data via the API
but we otherwise do not use this data.

+-----------------------------------------------------------------------+
| User can report that a mentor is transferring to another school. This |
| is not mandatory.                                                     |
|                                                                       |
| *🙋 This is to allow SITs to tidy their dashboard and mark mentors    |
| who are leaving / have left if they want to (see [design              |
| history                                                               |
| ](https://teacher-cpd.design-history.education.gov.uk/manage-training |
| /facilitating-participants-moving-schools-during-their-induction/)).* |
+=======================================================================+
| Specify leaving date, which can be in the past or future [(no         |
| constraints?)]{.mark}                                                 |
|                                                                       |
| *💻 This date becomes the trigger for removing the mentor from the    |
| school's mentor pool. [Also removes mentorship links?]{.mark}*        |
+-----------------------------------------------------------------------+
| Leaving date not shown in the service once it has been submitted, and |
| can't be changed.                                                     |
|                                                                       |
| *💻 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| [Email is sent to the ppt on confirmation?]{.mark}                    |
|                                                                       |
| *[🙋 ???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| [Email is sent to the LP?]{.mark}                                     |
|                                                                       |
| *[🙋 ???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| On the leaving date, mentor is removed from the school's mentor pool. |
|                                                                       |
| *💻 Unless the mentor is working across multiple schools, they are no |
| longer available to mentor ECTs at the school so are not shown in the |
| dashboard.*                                                           |
+-----------------------------------------------------------------------+
| Mentor cannot be re-added once they have been reported as leaving /   |
| have left.                                                            |
|                                                                       |
| *💻 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+
| User cannot report through the service if mentor is leaving for any   |
| reason other than transferring to another school.                     |
|                                                                       |
| *💻 [???]{.mark}*                                                     |
+-----------------------------------------------------------------------+

### 

### **Remove an ECT** 

[Context:]{.mark}

+-----------------------------------------------------------------------+
| [Only if the ECT is 'Exempt' from statutory induction?]{.mark}        |
|                                                                       |
| *[??? Previously a remove journey for unvalidated ppts]{.mark}*       |
+=======================================================================+
+-----------------------------------------------------------------------+

### **Contact support or provide feedback on the service**

Context: Users may need to access support whilst using the Manage ECTs
service. We also want to encourage them to provide service feedback.

+-----------------------------------------------------------------------+
| User can provide feedback via the feedback form at any point,         |
| including before logging into the service.                            |
|                                                                       |
| *💻 This follows the [Gov.uk service manual for measuring user        |
| satisfaction](https://www.g                                           |
| ov.uk/service-manual/measuring-success/measuring-user-satisfaction).* |
+=======================================================================+
| User can email                                                        |
| continuing.professional-develop[ment@digital.education.gov.uk]        |
| (mailto:continuing-professional-development@digital.education.gov.uk) |
|                                                                       |
| *💻 This is to allow users to access support for any issue or query   |
| they may have with the service.*                                      |
+-----------------------------------------------------------------------+
| There is no limit on how many times a user can submit feedback or     |
| contact support.                                                      |
|                                                                       |
| *💻 There is no reason to limit feedback or support per user - users  |
| may experience multiple issues that they need support with, and       |
| feedback is anonymous so we have no way of limiting feedback per      |
| user.*                                                                |
+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+

### **View guidance on how to set up and manage ECF training**

Context: Schools can find links from the service to gov.uk guidance for
managing ECF training.

+-----------------------------------------------------------------------+
| User can navigate to guidance on [how to set up training for          |
| ECTs](https://w                                                       |
| ww.gov.uk/guidance/how-to-set-up-training-for-early-career-teachers). |
|                                                                       |
| *🙋 This is to provide an overview of what registration involves in   |
| the Manage ECTs service.*                                             |
+=======================================================================+
|                                                                       |
+-----------------------------------------------------------------------+

# Lead provider user

### Find schools delivering ECF-based training in a given cohort and view details of a specific school

Context:

+-----------------------------------------------------------------------+
| Must specify a cohort in the request.                                 |
+=======================================================================+
| Successful request will show school details including school name,    |
| URN, cohort, type of training programme they have chosen to deliver,  |
| and whether they have confirmed partnerships in place for the         |
| cohort/academic year.                                                 |
+-----------------------------------------------------------------------+
| API will only show schools that are eligible for funded ECF-based     |
| training programmes within a given cohort. API will not show schools  |
| that are ineligible for funding in a given cohort. If a school's      |
| eligibility changes from one cohort to the next, results will default |
| according to the latest school eligibility.                           |
|                                                                       |
| *This ensures providers can see up to date information on whether a   |
| school is eligible for FIP and a potential partnership, and prevents  |
| LPs being able to see details of schools that are ineligible for      |
| funding.*                                                             |
+-----------------------------------------------------------------------+
| Can filter results by school URN.                                     |
+-----------------------------------------------------------------------+
| Can use school ID to find and view details for a specific school in a |
| cohort.                                                               |
+-----------------------------------------------------------------------+

Reasons:

### Find delivery partner IDs and view details for a specific delivery partner

Context:

  -----------------------------------------------------------------------
  Successful request will show DP details including DP ID, name, and
  cohort(s) they are registered for.
  -----------------------------------------------------------------------
  Can filter results by cohort.

  Can use DP ID to find and view details for a specific DP.
  -----------------------------------------------------------------------

### Confirm a partnership with a school and delivery partner

Context:

+-----------------------------------------------------------------------+
| Must specify cohort, school ID and DP ID in the request.              |
|                                                                       |
| Successful requests will return a response body with updates          |
| included.                                                             |
+=======================================================================+
| API assumes schools intend to work with a given provider for          |
| consecutive cohorts. If a school user confirms existing partnership   |
| with provider will continue into the upcoming cohort, providers do    |
| not need take any action to continue existing partnerships from one   |
| cohort to the next.                                                   |
+-----------------------------------------------------------------------+
| In order for new providers to confirm partnerships with schools for   |
| an upcoming cohort, school users must first notify DfE that their     |
| schools will not continue their former partnerships with existing     |
| providers for the upcoming cohort. Until induction tutors have done   |
| this, any new partnerships with new providers will be rejected by the |
| API.                                                                  |
+-----------------------------------------------------------------------+

### View all details for all existing partnerships or a specific existing partnership

Context:

+-----------------------------------------------------------------------+
| View details of existing partnerships including cohort, school URN    |
| and ID, DP ID and name, SIT name and email.                           |
+=======================================================================+
| Details of partnership status are also shown:                         |
|                                                                       |
| -   Active - partnership between a provider, school and delivery      |
|     partner has been agreed and confirmed by the provider. Providers  |
|     can view, confirm and update active partnerships.                 |
|                                                                       |
| -   Challenged - partnership between a provider, school and delivery  |
|     partner has been changed or dissolved by the school. Providers    |
|     can only view challenged partnerships.                            |
+-----------------------------------------------------------------------+
| If partnership is challenged, the reason and date/time is also shown. |
+-----------------------------------------------------------------------+
| Can filter results by cohort.                                         |
+-----------------------------------------------------------------------+
| Can use ID to find and view details of a specific existing            |
| partnership.                                                          |
+-----------------------------------------------------------------------+

### Update a partnership with a new delivery partner

Context:

  -----------------------------------------------------------------------
  Use DP ID to update
  -----------------------------------------------------------------------
  Partnerships can only be updated when the status is active (not
  challenged by the school).

  -----------------------------------------------------------------------

### View all participant data or a specific participant's data

Context:

  -----------------------------------------------------------------------
  Successful requests will show participant details including name, TRN,
  training record ID, email, mentor ID, school URN, participant type,
  cohort, training status, participant status,
  -----------------------------------------------------------------------
  Can filter results by cohort and updated since a date/time.

  API will not present any data for participants whose details have not
  yet been validated by DfE.

  Might come across duplicate participants -- DfE will retire one
  participant ID in this case.

  Can use participant ID to find and view details of a specific
  participant.

  Doesn't show unfunded mentors?
  -----------------------------------------------------------------------

### View all unfunded mentor details (API v3 onwards)

Context:

  -----------------------------------------------------------------------
  A single mentor can be assigned to multiple ECTs, including ECTs who
  are training with other providers. 'Unfunded mentors' are mentors who
  are registered with other providers. These mentors may need access to
  the learning platforms used by their ECTs.
  -----------------------------------------------------------------------
  Successful requests will return a response body with mentor details of
  unfunded mentors who are currently assigned to ECTs, including the
  mentor's participant ID, name, email and TRN.

  Can use participant ID to find and view details of a specific unfunded
  mentor.
  -----------------------------------------------------------------------

### Notify DfE a participant has taken a break (deferred) from training

Context:

  -----------------------------------------------------------------------
  Participant can take a break from training (with intention to return)
  at any time, and LP must notify DfE in response.
  -----------------------------------------------------------------------
  Use participant ID to update training status to deferred.

  Report reason for deferral.
  -----------------------------------------------------------------------

### Notify DfE a participant has resumed training

Context:

  -----------------------------------------------------------------------
  Deferred participants can resume training at any time, and LP must
  notify DfE in response.
  -----------------------------------------------------------------------
  Use participant ID to update training status to active.

  -----------------------------------------------------------------------

### Notify DfE a participant has withdrawn from training

Context:

  -----------------------------------------------------------------------
  Participant can withdraw from training at any time and LP must notify
  DfE in response.
  -----------------------------------------------------------------------
  Use participant ID to update training status to withdrawn.

  Submitted declarations will only be paid if declaration_date is before
  the date of the withdrawal.
  -----------------------------------------------------------------------

### Notify DfE of a participant's training schedule

Context:

  -----------------------------------------------------------------------
  All participants are registered by default to a standard schedule
  starting in September.
  -----------------------------------------------------------------------
  LPs must notify DfE if a different schedule is needed using the
  participant ID.

  Schedule can't be changed if the participant has any previously
  submitted eligible, payable or paid declarations with a
  declaration_date which does not align with the new schedule's milestone
  dates. In this case the LP can void the relevant declarations, then
  change the schedule and resubmit backdated declarations.
  -----------------------------------------------------------------------

### View data for all participants who have transferred or a specific participant (API v3 onwards)

Context:

  -----------------------------------------------------------------------
  When school reports a transfer, LP can view data for participants who
  have transferred to or from a school they are partnered with.
  -----------------------------------------------------------------------
  When a participant is leaving them and this has been reported by the
  old school and/or new school, LP can see an updated participant status
  of leaving and the details of the end / start date depending on what
  has been reported by the schools.

  When a participant is joining them and this has been reported by the
  old school and/or the new school, LP can see an updated participant
  status of leaving and the details of the end / start date depending on
  what has been reported by the schools.

  When transfer is complete, the old provider should report the
  participant as withdrawn from training to DfE.

  Can find and view a specific participant who has transferred.
  -----------------------------------------------------------------------

### Update a replacement mentor's schedule

Context:

  -----------------------------------------------------------------------
  A new mentor can be assigned to an ECT part way through training,
  replacing the ECT's original mentor.
  -----------------------------------------------------------------------
  Providers must notify the DfE of replacement mentors by updating their
  training schedule.

  If a replacement mentor is already mentoring another ECT and they
  replace a mentor for a second ECT, the first ECT takes precedence. In
  this instance, the provider should not change the mentor's schedule.

  XXX

  For API v3 onwards, a replacement mentor's schedule, and any associated
  declaration submissions, do not need to align with the ECT they are
  mentoring.

  -----------------------------------------------------------------------

### Test the ability to submit declarations in sandbox ahead of time

Context:

  -----------------------------------------------------------------------
  Use the service to do the same tasks with the same rules as above with
  test data.
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

### Submit a declaration to notify DfE a participant has started, been retained, or completed training

Context:

  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

### View all previously submitted declarations

Context:

  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

### 

### View a specific previously submitted declaration

Context:

  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

### 

### Void or clawback a declaration

Context:

  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

### View specific statement payment dates or all statement payment dates

Context:

  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

## **CSV upload service**

CSV upload:
<https://manage-training-for-early-career-teachers.education.gov.uk/lead-providers/partnership-guide>

### Sign in to the Manage ECTs service

Context:

  -----------------------------------------------------------------------
  Individual nominated to access the service
  -----------------------------------------------------------------------
  When user enters the registered email into the service login page, an
  email is sent to their email with a magic sign in link to sign into the
  service.

  -----------------------------------------------------------------------

### Confirm partnerships with schools

Context:

+-----------------------------------------------------------------------+
| Upload a separate CSV list of schools for each DP who will be working |
| with them.                                                            |
+=======================================================================+
| CSV must include one (first) column with school URNs, with a new      |
| school on each row and no empty rows between URNs and no other data.  |
+-----------------------------------------------------------------------+
| Partnership will not be confirmed if:                                 |
|                                                                       |
| -   School already recruited and confirmed by another provider        |
|                                                                       |
| -   URN not valid                                                     |
|                                                                       |
| -   School already confirmed and is on the provider's list            |
|                                                                       |
| -   School not eligible for inductions as per our GIAS list of        |
|     eligible schools                                                  |
|                                                                       |
| -   School not eligible for funding from DfE (they can only do CIP)   |
|                                                                       |
| -   School programme not yet confirmed -- SIT has not yet logged into |
|     the service to confirm if they will deliver training using a      |
|     DfE-funded training provider this year and/or will continue with  |
|     their current provider.                                           |
+-----------------------------------------------------------------------+
| Can continue with any schools that don't have errors, or can update   |
| the CSV and reupload.                                                 |
+-----------------------------------------------------------------------+
| School sent an email on confirmation, which includes a link to        |
| challenge the partnership if it is incorrect.                         |
+-----------------------------------------------------------------------+
| If partnership is reported as incorrect, LPs can't receive payment    |
| for that school.                                                      |
+-----------------------------------------------------------------------+
| Email will be sent to LP when school challenges the partnership and   |
| notification will be shown to LP in the service, including the reason |
| the partnership was challenged.                                       |
+-----------------------------------------------------------------------+
| Further contact with the school to resolve the issue will be offline  |
| outside of the service.                                               |
+-----------------------------------------------------------------------+
| If school challenged the parentship incorrectly, LP can reupload the  |
| school in a CSV again.                                                |
+-----------------------------------------------------------------------+

### View ECT, mentor and SIT details

Context:

  -----------------------------------------------------------------------
  Can view list of schools LP has a confirmed partnership with.
  -----------------------------------------------------------------------
  Can view total number of schools recruited.

  Can view details of partnered schools, including school name, URN and
  induction tutor contact information.

  Can search for a school in a specific cohort?

  Can see total number of ECTs and mentors added by each school
  -----------------------------------------------------------------------

### Contact support or provide feedback on the service

Context: Users may need to access support whilst using the API.

+-----------------------------------------------------------------------+
| Can email                                                             |
| <continuing-professional-development@digital.education.gov.uk> or can |
| use Slack channels.                                                   |
|                                                                       |
| *🙋 This is to allow users to access support for any issue or query   |
| they may have with the service.*                                      |
+=======================================================================+
| Can complete [feedback                                                |
| form](https://for                                                     |
| ms.office.com.mcas.ms/Pages/ResponsePage.aspx?id=yXfS-grGoU2187O4s0qC |
| -YkKKgAihPhLr_Bqhw1DVMZUMjlKMU4xRlNCTUk0WEVTVTdOVDNMUDFWWCQlQCN0PWcu) |
| (same form as for school users) in the CSV upload service.            |
|                                                                       |
| *💻 This follows the [Gov.uk service manual for measuring user        |
| satisfaction](https://www.g                                           |
| ov.uk/service-manual/measuring-success/measuring-user-satisfaction).* |
+-----------------------------------------------------------------------+

### View API guidance

Context: LPs can view guidance on how to use the API for managing ECF
training.

+-----------------------------------------------------------------------+
| *User can view guidance on how to use the API.*\                      |
| *🙋 This is to provide an overview of how LPs can use the API and     |
| what they need to report.*                                            |
+=======================================================================+
| User can view details of updates to the API.                          |
|                                                                       |
| *🙋 This is to ensure LPs are informed of any changes that happen     |
| with how the API works.*                                              |
+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+

# DfE user

-   [The DfE has previously advised of the possibility that participants
    may be registered as duplicates with multiple participant_ids. Where
    the DfE identifies duplicates, it will fix the error by 'retiring'
    one of the participant IDs, then associating all records and data
    under the remaining ID.]{.mark}

-   [Manual process for merging / closing / opening schools and greatly
    depends on things like whether the school has a successor,
    participants etc - and what training programme they\'ve
    selected]{.mark}

```{=html}
<!-- -->
```
-   [If the ECT doesn't have an induction start date recorded, they are
    assigned a temporary cohort to enable access training while the AB
    has not yet recorded their induction start date]{.mark}

-   [Replacement mentors]{.mark}

-   [Cohort allocation]{.mark}

-   [Eligibility for funding :
    <https://teacher-cpd.design-history.education.gov.uk/manage-training/iterations-to-eligibility-checks/>]{.mark}

Syncing our school list with GIAS

Sending out reminder emails -- manual / scheduled comms

Checking eligibility

Setting up cohorts & schedules

Assigning participants to a cohort temporarily / permanently

Setting / updating participant statuses

Calculating grant funding

## Calculating payments for providers

What is referred to as the 'payment engine' is a piece of code in the
same ECF application that calculates payments for LPs.

Provider payments are made up of:

-   set-up fee

-   service fee

-   uplift fee

-   output payment

To calculate the payment we need to know the:

-   participant recruitment target

-   volume banded price per participant

-   actual number of participants declared at each milestone

-   number of declared participants eligible for uplift

The per-participant price is usually paid 60% via output fee & 40% via
service fee.

Financial statements are produced and paid monthly. As well as the
calculated payment amount, the financial statements include:

-   Additional adjustments

-   Clawbacks

-   VAT

Financial statements are viewable by any internal DfE member with
'finance access'. Users will see an 'Authorise for payment' button
underneath the summary on the financial statements that include output
fees and where the deadline date has passed. This allows them to
'freeze' the statement and conduct their assurance tasks on a statement
without the numbers on the statement changing. It transitions eligible
declarations from the 'payable' state to the 'paid' state. This blocks
providers from being able to void those declarations. If a void does
happen after this point it is clawed back, rather than voided. Once the
statement has been authorised for payment It also places a tag on the
relevant financial statement showing the time and day the statement was
authorised 'e.g. Authorised for payment at 10:30am on 5 Aug 2023'

Statement can have different types of declarations -- payable \> paid,
awaited clawback \> clawed back\
![](/media/image4.png){width="4.475275590551181in"
height="4.802083333333333in"}

Audit trail -- not visible but exists

Contract managers can download a copy of the statement and a list of the
submitted declarations within it to share with providers. Providers can
see the information in the statement via API v3.

*ECF volume banded prices*

Each provider is required to specify a target recruitment number for
participants and quote volume banded prices.

-   There were originally 3 bands.

-   Each band must have a lower price-per-participant than the previous
    band.

-   Volume banded pricing is applied to both service fee and output fee.

Band D was introduced when the government made more funding available
for ECF and the DfE invited lead providers to increase their recruitment
targets.

-   Band D is paid the same per-participant price as Band C.

-   For Band D 100% of the per-participant price is paid via output fee.
    There is no service fee component.

-   Some providers don't have a Band D

**[PUTTING THIS HERE TEMPORARILY TO SHOW WHAT THE STATEMENTS ACTUALLY
LOOK LIKE FOR ANYONE WHO HASN'T SEEN -- NEED TO REMOVE]{.mark}**

![](/media/image5.png){width="3.0682152230971127in" height="7.5in"}

**Set-up fee**

The set-up fee is an amount that providers can claim to cover the costs
of standing up the service. It is effectively an advance. The maximum is
£150k.

The set up fee is paid by being added into the service fee for Band A
participants:

-   We have a set figure we've agreed to pay providers for set up costs.

-   We take that amount and divide it by the amount of months in the
    contract.

-   Then we take that monthly payment and divide it by the amount of
    **target** participants in band A.

-   We adjust the service fee for Band A participants so that it
    reflects service fee + set-up fee combined.

Note, in some cases where LPs are underperforming the target no. Of ppts
may be updated, which impacts the set up fee.

**Service fees**

Service fees are a fixed amount paid monthly and are based on the
recruitment target, not the number of participants actually recruited.
Contract management provide the total contract value and length and the
service fee amount is determined by dividing 60% of the contract value
by the contract length.

It is calculated as 40% of the banded per participant price, multiplied
by the **target** participants per band, divided by the number of months
of the contract.

For example:

![](/media/image6.png){width="6.991898512685914in"
height="1.534332895888014in"}

Source: Contract management provide total contract value and length.
Amount is determined by 60% of the contract value divided by contract
length.

**Uplift fees**

The uplift fee is a bonus that is paid to providers for recruiting
participants from schools in deprived areas.

-   It is £100 per eligible participant that receives a Started
    declaration.

-   It is paid as a single payment at the first milestone.

-   Eligibility is determined by the participant's school's score for
    sparcity and pupil premium (updated before opening registrations
    each year).

-   Although a participant may be eligible for both pupil premium (£100)
    and sparcity uplift (£100) payments, they will only receive a £100
    payment in total.

**Output fees**

The output payment is a variable amount paid according to schedule
milestone dates. There are typically 6 output payments (according to a
standard schedule).

-   It is based on the number of declared participants, not the
    recruitment target.

-   It is calculated as 60% of the banded participant price, multiplied
    by the participants per band, multiplied by the milestone weighting.

-   Started and completed milestones are weighted at 20%, the 4 retained
    milestones at 15% each.

![](/media/image7.png){width="2.857734033245844in"
height="2.3318471128608924in"}

[How do 'Extended' declarations work??? How do replacement mentors fit
in?]{.mark}

[Ask from contract managers to add 3 additional declarations for ppts on
extended schedules -- on top of the standard 6]{.mark}

When a provider submits a declaration for a participant, there is
validation to check that:

-   The declaration has been submitted at the right time according to
    the participant's schedule, i.e. within the right milestone period
    (note, this could be backdated)

-   The participant is eligible for funding, i.e. funding status = true

-   The same declaration has not already been submitted for the
    participant

If any of these checks fail, the declaration is stored as ineligible and
is not assigned to a financial statement.

If these validation checks are passed, the provider's contract for the
academic year ('cohort' / funding pot) is referenced to check:

-   The value of the declaration for the participant

-   Whether the participant has any additional associated uplifts

-   The banding the participant should be assigned to

-   Whether the count of declarations is below the LP's recruitment
    target, i.e. below the maximum number of declarations allowed for
    the contract

Based on these details, the output fee amount is calculated and added to
the next available statement.

**Manual adjustments**

There are some one-off additional payments added to financial statements
(e.g. IT service charges). These are added manually by contract
managers, outside of the calculation. Contract managers enter this in a
field in the finance tool.

**Clawbacks**

DfE can claim back money from providers via clawbacks. If money was paid
in error and declarations are voided, rather than DfE expecting LPs to
pay the money back in a separate process - we deduct the amount due from
the amount to be paid on the financial statement. Clawbacks cover the
different declaration types (e.g. started, retained 1 etc) and uplift.

[Need details - speak to Colin]{.mark}

[Usually provider submits in error]{.mark}

[Ppts moving cohorts -- need to void declarations first. In this case
provider would have to resubmit the declarations that have been
voided]{.mark}

# Appropriate body user

## TRA's appropriate body portal

### **Get access to the TRA's appropriate body sign in**

Access to the AB portal, and user management, is administered via DfE
sign-in.

*🔒* *Within DfE Sign-In, each organisation has a nominated approver,
and that person (rather than DfE personnel) is responsible for
adminstering user requests for their organisation. This keeps the data
safe from people within organisations that should not have access to
it.*

ABs as an organization are added or removed as needed through liaising
with the induction data collections team in the TRA via email.

*🔒* *This means organisations can only get access that are legitimately
appropriate bodies. Policy outlining who can be an appropriate body:*
[Appropriate bodies guidance - section
3:1](https://assets.publishing.service.gov.uk/media/661d459fac3dae9a53bd3de6/Appropriate_bodies_guidance_induction_and_the_early_career_framework.pdf)

### **View records for early career teachers that are already registered**

They can view historical records for ECTs they have claimed in a list on
their Appropriate body account homepage.

They can also view their appropriate body ID. This is referred to later
as an employer ID.\
*📊*

### 

### **Individually claim an ECT for their induction status with the TRA**

The process of 'claiming' an ECT refers to an AB telling the TRA which
ECTs are currently training at their schools.

The appropriate body needs to enter both the date of birth and the TRN
number for the ECT record to show up and be claimed.

*🔒* The AB needs both the TRN and DOB as a data privacy measure to
ensure that the AB is only searching for ECTs they already have links
with. This search locates the record in the database of qualified
teachers (DQT).

If there is no TRN and DOB match, then an error message appears. The AB
would then liaise with our induction data collections team/the teacher
as needed to verify data.

The record will still show but have a blank field in the QTS date
sections if they don't have QTS yet.

If the ECT has previously failed induction, they cannot do induction
again.

*📜 This is due to policy restricting those who have failed from
reapplying to practice teaching*

*([AB
guidance)](https://assets.publishing.service.gov.uk/media/6629237f3b0122a378a7e6ef/Induction_for_early_career_teachers__England__statutory_guidance_.pdf)*

if an AB tries to claim an ECT who is exempt from the web UI, or via a
bulk upload, it gives a message saying they are exempt.

*📜* Those who are exempt cannot be claimed as they don't need to train
as an ECT in order to teach

When the portal pulls up the record for the ECT, it would show:

**Status**

-   Alerts

-   The date they achieved QTS

-   Induction, which is the current status of their induction. This
    status would be one of the following: - in progress/pass/fail/
    extended/ not yet completed (when they have stopped induction with
    their current appropriate body but not finished their induction)

**Teacher details**

-   Their title

-   Forename

-   Middle name(s)

-   Surnames

**Initial teacher training**

-   Qualification

-   ITT establishment

-   Programme type

-   Subject 1

-   Subject 2

-   Subject 3

-   Age range

-   Course end date

-   Course result

-   Class and division

**QTS status**

-   Qualified teacher status

-   QTS date

-   Date of Partial Recognition

**Induction status**

-   Induction status (In progress/Not yet
    completed/Extended/Passed/Failed)

-   Eligible to complete a one-year induction period under transition
    arrangements

*📜* *This part* *was related to temporary provisions when the ECF came
in. If someone, as of 1 September 2021, had started but not completed
induction, they had until 31 August 2023 to complete induction under the
'old regs'. TRA populated this themselves, based on data they had. ABs
cannot edit it.*

*The transition period is over, so this is now a 'no' for everyone.*

There are provisions in the regulations for ABs to offer a reduced
induction. Appropriate bodies have discretion to reduce the length of
the induction period to a minimum of one term (based on a school year of
three terms) to recognise previous teaching experience.

Induction history is shown, as subsection of induction status, if the
ECT has a previous appropriate body(s) than their current one.

*🙋* This section is so that ABs can track where their ECTs have been
and how much induction they have served elsewhere.

The table shows the following:

-   Previous appropriate bodies

-   Start date (when the ECT started induction with the previous
    appropriate body)

-   End date (when the ECT stopped doing induction with the previous
    appropriate body, but did not pass or fail -- this is when they are
    released)

-   No of terms (this must be a whole number, and this is given when the
    ECT is released)

-   Induction programme type (FIP/CIP/DIY)

Below the induction history are 2 more subheadings:

-   Extension period (when an AB doesn't pass or fail them, but decides
    to extend their induction, this part will specify how much longer
    their induction is)

-   Induction status completion date (if passed, this will be the pass
    date, if failed, it will be the fail date)

The appropriate body user can claim the ECT for induction if they are
not already claimed by another appropriate body. If they are claimed by
another appropriate body, they would not be able to do this.

*🙋* This allows the TRA to keep track of where an ECT currently is or
how many ECTs under an AB without overlaps in data.

When an appropriate body user tries to view an ECT record to claim them,
if the ECT is already claimed by another appropriate body, it would
state they were 'in progress' and the appropriate body they were in
progress with.

[*💻* They are unable to change this on the service so the appropriate
body user would have to reach out to the other appropriate body or the
TRA induction support team to get them to release the ECT.]{.mark}

*📜* [Sometimes, these appropriate bodies (particularly local
authorities due to policy changes) no longer exist so the induction
support team would help the ABs to navigate this.]{.mark}

When they are claiming an ECT, the appropriate body user needs to state:

1.  When the induction began for that ECT with that appropriate body

2.  What type of induction programme they are doing (FIP, CIP, DIY)

*📊* On 1, there is validation that makes sure the date given isn't
before the date QTS was recorded. This is because induction should only
start after they received QTS.

There are some discrepancies in the rules on the portal. Future dates
aren't allowed in the web update, but can get through the bulk/mass
import upload.

The end date must be before a start date for an induction period.

When this data is submitted, the appropriate body user would see the
employer ID and employer address. This is the same as the appropriate
body ID, and should show the appropriate body address.

### **Release an ECT so another school can claim them or because the ECT dropped out of teaching**

An appropriate body user can record an induction outcome of not yet
completed when they click to update induction details. \'Not yet
completed' means they did not finish their induction but are no longer
with that appropriate body.

When they do this, they must:

-   Confirm or update the induction start date for the ECT with their
    appropriate body -- this is auto populated from what they previously
    gave when first claiming the ECT but can be edited if needed

-   Give the induction end date for when the ECT stopped induction with
    their appropriate body

-   Give the number of terms served as a whole number. The number of
    terms can only be given at the point an outcome so this part isn't
    auto-populated and would need to be input

-   Confirm or update the induction programme type -- this is populated
    from what they previously gave

They would submit that and then it would update DQT.

'Not yet completed' is the only status option for an ECT leaving an AB
regardless of the circumstances.

If an ECT drops out of teaching, the appropriate body does not update
the ECT's record any differently to when they would release an ECT who
had changed appropriate body for their induction. The record just
remains as 'not yet completed'.

*💻* Sometimes, ECTs will potentially come back and finish induction
much later therefore keeping their record as not yet completed
regardless of reasons for leaving allows their record to be picked up
from where it was last updated.

### **Pass or fail an ECT\'s induction** 

This would be under where they Record an induction outcome.

The following data points are given, updated or confirmed for this:

-   Dates of when induction started and ended

-   Number of terms completed

-   Induction programme type.

*📊📜* *This is the data that's needed to be on the record when giving
an ECT an outcome*

The relevant date validations would apply here, no future dates or end
date before start date.

This is not the case when done in a mass upload as the DQT processes
mass upload data overnight.

*💻* This is because the system can't correct errors with validation
rules as it's done on a template and will simply bounce them back a day
after the upload once processed.

### **Extend an ECT\'s induction** 

There is a field for extending number of terms. The inputs to populate
this field would be:

-   Start date

-   Programme type

-   Length of the extension

If the person iscompleting their induction with the same AB, they don't
have to enter an end date or no. of terms. If the person is completing
their induction elsewhere, they must enter the end date and number of
terms.

### **Mass actions to update an ECTs record for their induction status with the TRA** 

Mass actions refer to an AB's ability to upload mass induction data as
opposed to the standard 1 by 1 record updates for ECTs.

This is done by uploading a CSV file (template given by the TRA) onto
the portal. The columns on the file are the same as the details needed
on the individual record but this allows ABs to update the TRA with all
their ECTs data much quicker.

You can also release an ECT and extend them using the mass upload file.

This is processed overnight so there are no immediate error messages
unlike the updating 1 record at a time route.

The TRA support team would email the AB of any discrepancies that
flagged up overnight and ask them to amend the errors.

*💻* Due to the processing happening overnight the ABs wouldn't receive
notifications to alert them of any errors and the system doesn't have a
way to update them built in, therefore the only way to amend errors is
via contacting the ABs through help desk.

There are some discrepancies in the rules on the portal. Future dates
aren't allowed in the web update, but can get through the bulk import.

## Check data for appropriate bodies

### **Access to the service**

The appropriate body nominates the users who require access by emailing
support. Support would then raise this as a second line ticket to the
policy and engagement team. The policy team would contact the lead
provider working with this appropriate body to confirm the user was
valid. There is admin functionality where they can then add users to the
appropriate body in the Manage ECT admin tooling.

*🔒 Only approved appropriate body users can be added to view this data.
As the check data service shows personal information for ECTs, it would
be a GDPR breach to show this to users that do not require access.*

*📜 There were strict directions from policy to define who had access to
this data. This is why it is escalated to policy teams, not just support
teams. Appropriate bodies are often delivery partners too. The policy
team would check with the lead provider to give access. The Appropriate
bodies and regulation team gives information to the policy team on who
is serving as an appropriate body.* *Lead providers give the information
on delivery partners.*

Those users will then receive an email notification that they can sign
in.

*💻The email notification is used to alert users they can use the
service.*

If an appropriate body also acts as a delivery partner, access is given
to each check data service separately.

*💻Some appropriate bodies may be delivery partners, but they have
differing responsibilities for each role, and in theory might be
responsible for different ECTs. Delivery partners are also responsible
for mentors, not just ECTs.*

*🔒 Splitting the responsibility up allows them to see what is relevant
for their role for their organisation. Some colleagues may only be
responsible for appropriate body responsibilities, not delivery partner
responsibilities, or vice versa.*

### **Sign in to the service**

The user, if granted access, can try to sign in. This will then send
them a 'magic link' in an email to enable sign in.

*💻 Magic link approach was decided to be the best sign in option at the
time.*

If the appropriate body user is also granted access to the check data
for delivery partner service or any other related services, they will be
required to state which role they need to carry out for that session.

*💻Some appropriate bodies may be delivery partners, but they have
differing responsibilities for each role, and in theory might be
responsible for different ECTs. Delivery partners are also responsible
for mentors, not just ECTs.*

*🔒 Splitting the responsibility up allows them to see what is relevant
for their role for their organisation. Some colleagues may only be
responsible for appropriate body responsibilities, not delivery partner
responsibilities, or vice versa.*

### **View data for ECTs registered by SITs to their appropriate body**

The data that is available to view in the service is the data submitted
by SITs in the Manage ECTs service about ECTs.

*🙋📊 This was built for appropriate bodies to cross-reference with
their own data and information on ECTs with what schools had submitted
in Manage ECTs. This could be useful when submitting other data to the
Teaching Regulation Agency as well.*

*It also meant that appropriate bodies could follow up when necessary
with schools, for example when:*

-   *a school has indicated they are using the appropriate body on
    Manage ECTs, but has not registered the ECT's details directly with
    them*

-   *a school has registered an ECT's details directly with them but has
    not registered the ECT correctly on Manage ECTs*

-   *an appropriate body has concerns that fidelity checks (needed for
    both CIP and DIY) may be required for an ECT's induction*

-   *an appropriate body may need to use this to double-check they have
    successfully registered for induction any ECTs on the TRA AB portal*

*There was also a hope that showing this information schools had
submitted on Manage ECTs, would reduce the workload of appropriate
bodies having to ask schools for the same information again in other
places.*

Appropriate bodies cannot see any data about mentors.

*🔒 Appropriate bodies are responsible for the induction of new
teachers. They are not responsible for any training mentors receive and
do not need to see their data.*

If there are users allocated to multiple appropriate bodies, they can
choose from a list of appropriate bodies which one they want to view the
data for.

*💻 This seems to be just how it was built, and a way for the user to
check what they needed to for their role as a particularly appropriate
body. It's unlikely or unheard of for someone to work for multiple
appropriate bodies.*

It only shows data for the current academic year.

*💻 This seems to be just how it was built, and it wasn't a priority to
expand to other academic years.*

**Fields that can be viewed about an ECT**

-   Full name

-   TRN

-   School URN

-   Status (defined below)

-   Induction type (FIP, CIP or DIY)

-   Induction tutor (their email)

*📊🙋 There was an exercise to consider what appropriate body would need
to see. The first 3 fields help them to ascertain if the ECT has been
correctly registered with them and matches their records. Most of these
fields are relevant to what an appropriate body would need to submit to
the TRA, or what school and who they would need to contact if there were
any issues. Information on the induction type also informs appropriate
bodies to if they need to do fidelity checks or not.*

**Statuses for an ECT**

-   Contacted for information

-   No induction registered - Check you've registered this ECT's
    induction with the Teaching Regulation Agency (TRA)

-   Not eligible for funded training - This means the ECT has either
    completed, failed, or is exempt from serving their induction

-   Checking QTS - We're awaiting confirmation of their qualified
    teacher status (QTS)

-   Induction confirmed - An induction period has been registered with
    the Teaching Regulation Agency (TRA) for this ECT

-   Participant deferred - This participant\'s provider has reported
    that they\'ve deferred. Contact the provider if you think this is
    wrong

-   ECT not currently linked to you - The school has indicated you\'re
    no longer acting as the appropriate body for this ECT

-   Induction completed - The Teaching Regulation Agency has recorded
    that this ECT completed their induction on 30 June 2023.

*📊🙋 The statuses were transformed from how they appear to school users
in Manage ECT to be more relevant to what appropriate bodies would need
to see. They can help an appropriate know what they might need to
action, e.g. to check in with a school if they're not eligible, or to
make sure they've registered them for induction in the TRA AB portal.*

**Filters a user can apply**

-   Search by school name, URN, ECT name or TRN

-   Filter by status

*🙋 This helps appropriate bodies filter to ECTs they are interested in
finding out about.*

*For example, filtering by status allows them to see ECTs where they do
not have induction registered on the TRA's AB portal. They could then
follow up these queries with the school induction tutor or school.*

*Equally, filtering by school can allow them to check that the school
has registered on Manage ECTs correctly all the ECTs they are
responsible for the induction of.*

*It can help them find mistakes for particularly schools.*

### **Download the data as a CSV**

The data shown on the page is downloaded as a CSV. It remembers the
filters or search that has been applied.

*🙋 This is to help with appropriate bodies processes and record
keeping, so they can choose to compare the data in Manage ECTs, the
TRA's AB portal and their own systems how they want to. They can also
use this to export data which will later disappear when the service
updates to the next academic year.*

# Delivery partners

## Check data for delivery partners

### **Access to the service**

Originally, lead providers gave DfE information on all the delivery
partner admin users they thought would require access. For new users,
the delivery partner nominates the users who require access by emailing
support. Support would then raise this as a second line ticket to the
policy and engagement team. The policy team would contact the lead
provider working with this delivery partner to confirm the user was
valid. There is admin functionality where support users can add users to
the delivery partner.

*🔒 Only approved delivery partner users can be added to view this data.
As the check data service shows personal information for ECTs and
mentors, it would be a GDPR breach to show this to users that do not
require access. Delivery partner users can only access the service who
are covered by the data-sharing agreements between delivery partners and
lead providers.*

*📜 There were strict directions from policy to define who had access to
this data. This is why it is escalated to policy teams and checked with
the lead provider they work with.*

Those users will then receive an email notification that they can sign
in.

*💻The email notification is used to alert users they can use the
service.*

If a delivery partner also acts as an appropriate body, access is given
to each check data service separately.

*💻 Some delivery partners may be appropriate bodies, but they have
differing responsibilities for each role, and in theory might be
responsible for different ECTs and mentors.*

*🔒 Splitting the responsibility up allows them to see what is relevant
for each role, for those users that require it.*

### **Sign in to the service**

The user, if granted access, can try to sign in. This will then send
them a 'magic link' in an email to enable sign in.

*💻 Magic link approach was decided to be the best sign in option at the
time.*

If the delivery partner user is also granted access to the check data
for appropriate bodies service or any other related services, they will
be required to state which role they need to carry out for that session.

*💻 Some delivery partners may be appropriate bodies, but they have
differing responsibilities for each role, and in theory might be
responsible for different ECTs and mentors.*

*🔒 Splitting the responsibility up allows them to see what is relevant
for each role, for those users that require it.*

### **View data about the participants linked to their delivery partner**

The data that is available to view in the service is the data submitted
by SITs in the Manage ECTs service about ECTs.

*🙋📊 This was built for delivery partners to help them support schools
better and reduce the data gathered from schools by delivery partners.
It can be used to cross-reference with their own data and information on
ECTs with what schools have submitted in Manage ECTs. There is nothing
they can submit or do to the data, this would have to go via their lead
provider.*

*Some delivery partners reported it is also the main way they know how
many ECTs they are getting registered with them, and if they're
correctly registered. It was hoped it would reduce workload for
schools.*

*Delivery partners also reported it is difficult to support schools with
a limited ability to view the processes and data behind ECF registration
with DFE. Delivery partners may be able to help chase certain tasks for
schools, for example, ABs registering induction data correctly with the
TRA.*

**Data on a participant**

-   Full name

-   Email address

-   TRN (Validated against DQT)

-   Role (ECT or mentor)

-   Lead provider (If populated, this is the confirmed DfE-funded
    training provider. If blank, this means the training provider hasn't
    been confirmed or the ECT's school is delivering the DFE-accredited
    materials directly)

-   School

-   School unique reference number (URN)

-   Academic year (The year the participant started their ECF-based
    training)

-   Status (Gives information on if the ECT does not have QTS or has a
    prior induction registered against them in the DQT)

**Statuses for a participant**

-   Contacted for information

-   DfE checking eligibility

-   Not eligible for funded training

-   Checking QTS

-   Training or eligible for training

-   Participant deferred

-   No longer being trained

-   Induction completed

### **Filter the data on ECTs/mentors**

The user can search for a participant by:

-   Participant name

-   School name

-   TRN

The user can also filter the data shown by:

-   Participant role

-   Academic year

-   Status

*🙋 📊 These filters were chosen to best meet the needs of delivery
partners. Delivery partner users can filter by status so they can
reconcile their records and see when a change in status has been
received and actioned.*

### **Download the data as a CSV**

The data shown on the page is downloaded as a CSV. It remembers the
filters or search that has been applied.

*🙋📊 This download is used to reconcile delivery partner records with
DfE Manage ECT records, and create communication lists. It was also
hoped it would reduce delivery partners needing to request information
directly from schools, reducing their burden.*

# Grant funding summary

## Grant funding for induction and training

There are 2 types of grant funding -- for induction and for training.

-   Induction grant funding includes

    -   Year 1 Core Funding.

    -   Year 2 Time of Timetable Funding. Covers both:

        -   5% off timetable in year 2 of induction

        -   20 hours of mentor support in year 2 of induction

-   This funding is dedicated only for schools on the FIP programme.
    Training grant funding includes:

    -   Year 1 & 2 Lead Provider Funding.

    -   Backfill mentor Funding.

## Training grant funding. Year 1 & 2 Lead Provider Funding. 

**What does it consist of?**

DfE pays Lead Providers to train ECTs and mentors in the full induction
programme. Lead Providers have to give proof that they are in fact
training mentors and ECTs, they do this through 'declarations'.
Declarations are statements of work. They are meant to provide 3
declarations per year, 6 for both years. They do this through the API
'service' DfE supports.

**How are the payments structured?**

To manage payments, DfE has ongoing contracts (also called 'call off
contracts') with LPs that cover the 2 years of training a group of ECTs
and mentors receive. Each academic year there is a new 'call off
contract' to cover the new group of participants that comes in. Each new
group of participants is often called a 'cohort'.

**So it's just a one-off payment?**

No. There are 3 types of payments to LPs.

-   **Service fees**. **These are fixed.** They are an amount that
    providers will be paid regularly regardless of things like
    participant numbers. These are just a set payment for providing the
    service. They are paid monthly for a set time. Once passed,
    statements have £0 service fees.

-   **Output fees. These are flexible.** DfE pays providers an \'output
    fee\', whose value depends on a range of factors, when providers
    train a participant up to a set milestone. Providers report this via
    the API (subject to validation) using \'declarations\'.

-   **Uplift fees.** DfE pays an additional \'uplift fee\' for
    participants in specific courses and circumstances e.g. schools with
    [high pupil
    premium](https://www.gov.uk/government/publications/pupil-premium/pupil-premium)
    (pupils who are recorded as eligible for free school meals, looked
    after by a social worker, etc).

**What is the journey?**

Internal DfE staff can access providers\' financial statements via the
finance tool. When a milestone period is hit, DfE staff conduct
assurance and then send out a copy of the financial statement to Lead
Providers, along with a CSV of the declarations that make up the
statement. Lead Providers check this against what they expected and then
invoice DfE. EFSA then makes the payment.\
Throughout the process DfE also conducts audits, where they will select
a sample of LP data and ask for evidence of training, to reduce the risk
of any fraudulent payments.

**What is the eligibility policy?**

All lead providers must declare their subcontracting arrangements (with
delivery partners) for the period 1 August to 31 July through the
[manage your education and skills funding
(MYESF)](https://skillsfunding.service.gov.uk/) service. Lead Providers
are required to report at least twice a year.

At the start of the period, Lead Providers must:

-   Submit their forecasted delivery on the number of ECTs and mentors
    trained

-   Update their declaration whenever they make any change to their
    Delivery Partners -- this includes adding or removing subcontractors
    (delivery partners) or changing the information of a previously
    submitted declaration.

At the end of the period, Lead Providers should submit their actual
delivery.

If Lead Providers do not subcontract but receive direct funding, they
need to make a 'nil declaration'. To do this, Lead Providers will need
to know:

-   The names of their subcontractors

-   How much money they will have paid their subcontractor from 1 August
    to 31 July

-   Which funding stream the lead provider is subcontracting

-   The number of learners or apprentices where the training will take
    place

Lead providers who subcontract also need to:

-   Publish their policy for subcontracting delivery on their website

-   Include a link to this policy as part of the subcontractor
    declaration (excluding employer providers who only deliver the
    apprenticeship funding stream)

If DfE does not receive this as part of their declaration, we will
contact LPs to provide the link separately.

## Training grant funding. Backfill mentor funding. 

**What does it consist of?**

DfE pays schools to cover the time mentors need to train to be a mentor
during both years of induction. It is paid to the latest school the
mentor has been registered. This school is responsible for breaking up
the grant and dividing it between previous schools the mentor was at.

**From a funding standpoint**, there are 2 types of mentors.

-   Replace**ment** mentor. A **new** mentor joining the **ECF mentor
    training programme** to replace an existing mentor. These have
    different schedules on CPD. This mentor needs new funding allocated
    to them.

-   Repla*cing* mentor. A mentor who is already on the programme who
    starts to support an ECT (new or existing). This mentor does not
    need new funding as they have already had this allocated.

**How are the payments structured?**

There are 2 payments made to schools at two different moments. If the
mentor has transferred, it is paid to the latest school the mentor has
been registered. This school is responsible for breaking up the grant
and dividing it between previous schools the mentor was at.

To release payment for year 1, the grant funding team needs to do the
following checks.

-   Make sure the mentor's lead provider has a 'start' declaration (the
    declaration that confirms the beginning of training).

-   Make sure the mentor cannot have withdrawn from the DfE-funded
    mentor training as of the date the data cut happens (1 June 2023).

-   An 'instalment 1' payment should not have been paid for that mentor
    previously as well (to prevent double funding).

To release payment for year 2, the grant funding team needs to do the
following checks.

-   Make sure the mentor's Lead Provider has submitted at least one
    'engagement declaration' (either declaration 4, 5 or \'completion\')

-   The mentor has not previously have been paid for an 'instalment 2'
    payment.

-   Check to see if a 'completion declaration' has been accepted. If it
    has, then this will also trigger an instalment 2 payment.

On top of this, there are certain checks that need to be made for new
(replacement) mentors. If it's a replacement mentor, the grant funding
team need to check if:

-   The mentor they replaced received instalment 1 or 2

-   If the original mentor didn't receive instalment 1, the replacement
    mentor can receive it if they meet the criteria

-   If the original mentor didn't receive instalment 2, the replacement
    mentor can receive it if they meet the criteria

-   If the replacement mentor did receive an instalment, the replacement
    mentor can also receive the same instalment if they are linked to a
    second ECT

**What is the journey for** **Beneficiaries?**

1.  School induction tutors register mentors with DfE using manage
    training for ECTs 

2.  CPD sends each mentor an email (so it's important the addresses
    provided are for active email accounts) 

3.  CPD checks that the mentor:

    a.  does not have any prohibitions, sanctions or restrictions on
        their record

    b.  has not previously received funding for ECF based mentor
        training

4.  SIT logs into manage training to check the status of these
    eligibility checks and get confirmation the mentor is ready to go.

**What is the eligibility policy?**

To be eligible as a school for this type of funding, you need to be

-   A state-funded school and establishment where induction can be
    served

-   Have a mentor signed up through manage training portal

-   Doing FIP programme

For the mentor to be eligible they need to

-   Be on a FIP programme

-   Have an active email

-   

Sign into manage training service and tell DfE their teacher reference
number (TRN) or National Insurance number, name and date of birth

-   Not have any (serious) prohibitions, sanctions or restrictions on
    their record

-   Can't have previously received funding for ECF based mentor training

## Induction grant funding. Year 1 Core Funding. 

This funding is meant to cover time off an ECT's school timetable to do
induction (10% of their scheduled time). It is provided by the
[Dedicated Schools Grant
(DSG)](https://www.gov.uk/government/collections/local-authorities-pre-16-schools-funding#dedicated-schools-grant),
calculated using the [national funding formula
(NFF)](https://www.gov.uk/government/publications/national-funding-formula-for-schools-and-high-needs).
The grant is paid to local authorities, who distribute the payment to
schools, by
[EFSA](https://www.gov.uk/government/organisations/education-and-skills-funding-agency)
(funding institution).

## Induction grant funding. Year 2 Time off Timetable.

**What does it consist of?**

This funding is meant to cover time off an ECT's school timetable to do
induction (5% of their scheduled time) and a mentor's time off timetable
to support the ECT through induction (20 hours). This funding is for all
schools regardless of programme.

To calculate this grant, the funding team need to know about training
data, specifically, declarations. This is because our ways to track an
ECTs induction time are messy, but the data provided for training
declarations is as validated as it gets.

**How are the payments structured?**

The grant funding team need to firstly figure out which ECTs and mentor
and in their year 2 of their induction. This is a surprisingly difficult
thing to calculate as years doing induction is NOT the same as years
doing training. ECTs pause, stop, defer, change schools often and track
these changes is at the core of many issues in the data collection
system.

[How \'Are they in their 2nd year?' is calculated.]{.underline}

-   For FIP -- if they have 4 declarations, we can safely assume they
    are in their second year of training.

-   For CIP -- CIP don't have declarations, so instead of trying to get
    who IS in the 2nd year, they calculate who is NOT -- who has NOT
    completed their first year based on their training registration
    date.

-   For DIY -- We have to check against DQT, SWO and call ABs directly
    and ask for ECT details.

Getting this data right is difficult because

-   Tracking the movements of an ECT (pause, stop, defer, changing
    schools\...) is dependent on AB and SIT updates. There are delays in
    this data coming through.

-   Once the data does come through, the data gathered for each
    programme type is different.

[\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--]{.underline}

**[NEED TO CHECK THIS WITH GRANT FUNDING TEAM]{.underline}**

[Once we have it, we need to organize those ECTs by cohort.]{.underline}

-   Cohorts are determined by the data point call_off_contract_year.
    Just FYI, a 'call-off contract' is (by definition) a contract
    between a supplier and a buyer. In this scenario, there is also a
    data point called 'call-off contract'

-   A call-off contract is by definition a contract between a supplier
    and a buyer. the call off contract is linked to a lead provider that
    a participant is associated with. This determines the funding 'pot'
    which pays for the participant's training. For example, 'a call off
    contract with EDT to train participants who began their training in
    the 2022--23 academic year'.

-   call_off_contract_year is an academic year within a call off
    contract. There can be multiple call_off_contract_years per
    call_off_contract. For example, the 2023 call-off contract covers
    participants who start in the 2023--24 academic year, and the
    2024--25 academic year. These are both call_off_contract_years. This
    is the true definition of the word 'cohort'.

-   Money is allocated per cohort. A cohort is a mirror of contract
    year, which follows an academic year. There is a call_of_contract
    per lead provider per the year. For example - for the Lead provider
    \'Ambition\' there are 2 call_of_contract data points, one for the
    academic year 2021-2022 and another for the academic year 2022-2023.

![](media/image2.png){width="5.666666666666667in" height="4.675in"}

[We also need to organize mentors by cohort.]{.underline}

-   We use the mentor training date to assign the mentor a cohort.

-   As with ECTs, we will assign a Mentor a "temporary" cohort based on
    when we think they will start their training.

-   Doing this will always enable the mentor to access training, even
    though mentors start their training at different times.

-   DfE will correct this cohort, if the provider identifies that the
    mentor has started their training at a different time.

**So it's just a one-off payment?**

**What is the journey?**

**What is the eligibility policy?**

From a policy standpoint, ECTs need to be the following to be eligible
for Y2TOT funding.

-   Work in one of the schools and establishments serving induction

-   Hold qualified teacher status (QTS)

-   Be registered as being in their second year of their induction after
    1 September 2021

Schools and establishments who employ ECTs with qualified teacher
learning and skills status (QTLS) are not eligible for DfE funding,
because they are exempt from statutory induction.
