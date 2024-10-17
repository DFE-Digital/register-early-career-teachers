---
title: Data model progress
---

## Partnership relationships vs default

Partnerships is a table between the lead provider, the delivery partner and the
school.

For each year, a school is linked with a lead provider and delivery partner.

When somebody transfers to a different school, sometimes they maintain their
delivery partner and lead provider-this forms a new kind of partnership called
a relationship.

### Impact

* This causes confusion for developers and reporting.

### Additional notes

The registration process still needs to capture the idea of a default, that is
contract-specific, to help speed up registration for SITs.

## A person is represented across many tables which introduces unintended duplication and confuses the source of truth

Some fields, e.g. email address, are stored in more than 1 place in the
application. There's no source of truth for what the email is and it's trickier
to work out if things are unique for that participant. The data is modelled
with some assumptions like they'll all sign in.

The data is not held in the right structure. An example of this is that the TRN
should be in the users table as opposed to the teacher profile table.

### Impact

* This creates duplication and also makes de-duping more difficult.
* It causes confusion.
* It makes it trickier to keep the data clean.

### Additional notes

Most of these problems are linked to email. Participants sometimes have
multiple email addresses for them because they might change school or they
might not have a school email yet.

Primary need for email is to award them?

Some emails are generic (e.g. `head@`) and this means the identify model might
get confused by them.

## Chronological timelines are difficult due to using the versions table

We don't currently record events that happen, instead we have to look for
individual records and try to create a timeline. We need to know what happened,
in what order and why.

It means developers have to get involved to work out why records are in the
state they are.

Sometimes due to inconsistency we also cannot work out why the records are they
way they are.

## Contract versions for ECF

We hold financial data for providers, which tends to change. When we want to
update those numbers, we have to update the contract, and bumping it up to new
versions. We need to commit code to do this. When a contract manager wants to
make a change, they have to go through a developer, which is very manual and
error prone.

### Impact

* It takes up a large amount of developer time and contract managers need to wait
  for changes.
* When there are errors, it has to be gone back to fix later.
* This should match how NPQ contracts are versioned and updated, but there will
  be more to it in ECF.

## Determining a cohort for a participant

The cohort lives on the profile, schedule and school cohort, and in induction
record on schedule, induction programme and maybe other places! They don't
always align. It's difficult to consolidate these.

### Impact

* Adds to developer confusion and leads to bugs in the service.
* Creates badly shaped data, e.g. a participant is in 1 cohort but their
  declaration is in a `statement_id` that belongs to another cohort.
* It might mean payments are incorrect and has to be clawed back.

### Additional notes

There's an admin tool to try and help consolidate the cohorts. Cohort means
different things to schools and to developers. Devs refer to the data point
`call_off_contract`, which is a contract corresponding to an agreement to train
either NPQs, or ECTs. Schools refer to the year an ECT started induction.

We need to:

* agree on how to speak about this data issue that doesn't overlap the
terms
* log **both** cohort and `call_off_contract_year` in our databases

[We have documented cohorts extensively](https://educationgovuk.sharepoint.com/:w:/s/TeacherServices/EbdTeLtClv9PtXD3ZghgLaUB6dWn_AY5cOnmkK01mU22NQ?e=fChpDR).

## Touch model for everything and determining changes for the API

We have `updated_at` timestamps for the API, when something changes, what should
that be? We get timestamps from 6 different places and try to put this there.

For an ECP participant record, we're using the profile. Someone changes
something on it, it appears someone updated it when we haven't.

### Impact

* Causes confusion for lead providers.

### Additional notes

We need something to make it easier to have 1 timestamp.

## Tight coupling between schools view of data and providers view, in respect to making and exposing changes

Information from schools can't be saved in our current data models, because it
can change something that needs human processes involved in it. Typically to do
with who they're working with or providers. We can't action changes (e.g. from
Zendesk) without checking with other people or teams.


### Impact

* Increases time developers spend
* Schools have to wait longer for it to be done, as there's another process to be
  done out of the service

### Additional notes

Service was designed to show the current situation, but found it was necessary
to see it was important to the full sequential story.


## Cohorts are linked to many different types of entities, are close to the surface and are tightly linked to financial records.

The visibility and restriction of these fields. Cohorts are linked to other
fields or tables in the database, and it's hard to ascertain answers to
questions about the data. Policy and financial are confused.

### Impact

* Code is difficult for developers to understand.
* Difficult to understand questions around an ECT's cohort.
* Payment engine cannot work counts accurately.

## How schools are managed in the database (GIAS type changes)

We've organised data for schools by copying GIAS data and linking to GIAS
records. This makes it difficult when there are changes on GIAS - we might
identify schools by URN, but a school might change their URN in the case of
academisation even though in reality it is the 'same school'. This means we
have to handle some tasks manually.

Every school is an entity with lots of information. When the school changes,
e.g. their name or URN, it means we need to spend a lot of time moving ECT
records and partnerships to different schools.

There's a tight coupling between the school and any other associations with
it. Another example of this, is when a school becomes an academy, and the URN
changes, we have to go through a lot of records to update this
information. This schools information is useful for lead providers and played
back to them too.

### Impact

* Increased developer time to make changes
* Confusion for policy teams and takes them time too
* Means the GIAS data needs to sometimes be manually updated in Manage ECT

## Fields stored in incorrect tables which makes changes difficult

Fields are stored in tables where it doesn't make sense for them to be. It's
unintuitive. An example would be A TRN being on the profile, not the user. We
need to check the location of fields/attributes makes sense.

### Impact

* Increased developer time and confusion.
* It makes it hard to keep things up to date.

## We can't handle changes to mentor or ECT eligibility

The eligibility for DFE-funded training is contingent on serving induction. If
induction is paused, the training should also be paused. The current data model
has a boolean attribute, which only shows the current status of eligibility. We
need to recheck on eligibility. DQT is the main source of eligibility. The
source for mentors is if they have been trained prior in the Manage ECT
service. It's difficult that we can't see when eligibility started and ended.

### Impact

* Currently, if the ECT's eligibility is set to false, a lead provider can't get
  historical declarations.

## Finding the active induction record isn't easy

Induction records are stored in a slightly unconventional fasion where any
changes are recorded as a new row rather than upgrading an existing one. We
also allow future records to be created, which are used to indicate future
standards. This means finding the 'active' one is complicated and slow.

### Impact

* The API doesn't perform very well and we need to do extra work in order to
  optimise it (pagination, advanced SQL)

## Lack of validation or uniqueness for fields in the database allows for duplicates to be created

An example is TRN. There should be validation on this field in the database to
prevent multiple people records with the same TRN.

### Impact

* Creation of duplicates and developer time taken.

## Statuses (eligibility or otherwise) for participants are calculated on the fly as opposed to being stored

It makes it difficult to work out the statuses of ECTs or mentors. We can't
easily show statuses in Google Cloud products like Big Query or Looker
Studio. Logic for statuses has to be applied later and it's very complex.

### Impact

* It increases the load on the app - however that isn't our biggest
  problem.
* It makes code harder to read and understand, which can slow development work
  e.g. our old eligibility codes for schools.
* It breaks reporting and makes it hard to quickly find information.
