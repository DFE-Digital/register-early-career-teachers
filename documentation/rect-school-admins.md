---
title: School admins in Register early career teachers
---

This document covers the service rules for school admins in Register early career teachers (ECTs).

In the service, we ask schools for information about ECTs and their mentors so DfE can:
- make sure they're trained, so they improve as a teacher or a mentor
- send funding to schools to give them time off timetable for training or mentoring
- publish statistics on how early career teaching programmes are performing

These are the rules we have determined so far for the new service. We'll continue to add to this over time.

School admins are also known as:

* school users
* school induction tutors (SITs)
* school induction coordinators

## Getting access to the service

For a school admin to get access to the service, they will need to use [DfE Sign in](https://services.signin.education.gov.uk/).

DfE Sign-in is how schools and other education organisations access DfE online services. We've decided to use it for Register ECTs because:
- schools use it for other services, and were getting confused in ECF1
- in research, most school users had an understanding of DfE Sign in
- access to the service historically worked through using info from Get information about schools, but many schools weren't aware of this
- it still makes sure the person accessing the service actually works for the school by going through an approval process

You can read more about why we chose to do this in [our design history](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/exploring-using-dfe-sign-in/).

To get access to the service, a school will need to request for approval. This is checked and actioned by whoever at their school has approval permissions. Once this is done, they will be able to sign into the service and view the records for their school.

## Accessing the service

We will not limit the number of users per school. This means multiple people can get access, unlike in ECF1.

You can read more about [why we made this decision in our design history](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/allowing-multiple-school-accounts/). 

## Registering an ECT

### Finding an ECT's record in the Teaching Record System

To find an ECT's teacher record, we need to check the Teaching Record System (TRS) API. The ECT needs a TRN and a teacher record to be eligible for training.

To do this, we ask for the ECT's TRN and date of birth. 

We should always ask for two fields of personal information before registering an ECT's record. This is because we need to make sure the person registering the ECT actually knows that ECT. If we just ask for TRN, they could be entering a random number.

If we can't find a matching TRN that exists, we tell the user the ECT's teacher record cannot be found.

If we can't find the ECT's record in the Teaching Record System API, but the TRN does exist, we ask for that ECT's national insurance number instead. We do this because potentially the date of birth stored on the teacher's record in the TRS is incorrect, or the one the school holds might be. It makes it more likely for the user to find the ECT's teacher record and confirm they know them.

If we still cannot confirm the user knows both the TRN and either national insurance number or date of birth, we tell them the record cannot be found.

Neither date of birth or national insurance number should be stored longer-term. It is just used for the initial finding and checking of an ECT's record in the TRS. You can read more [about our reasoning for this here](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/no-longer-storing-date-of-birth/).

### Checking the ECT is eligible to be registered for training

When an ECT is registered for training, we should check if their record already exists in CPD.

If the ECT being registered already exists as a mentor, we should not let them progress with registration. This is because a mentor undergoing ECT training is highly unlikely and it's probably a mistake.

If the ECT being registered already exists as an 'in progress' or 'completed' ECT at their school, we should not let them progress with registration. This is because the ECT record already exists and we do not want duplicates. If the ECT has 'left' their school, we should still let them progress with registration, as the ECT may have returned.

At this stage, when we check the TRS for the existence of the ECT's record, we also need to make sure:
- the ECT has not completed induction already
- the ECT is not exempt from induction

Whilst an ECT needs qualified teaching status in order to be eligible for funding for training, we do allow them to be registered in advance without it. 

This is because we know schools might want to register an ECT before they actually start working in a school. This might mean that ECT doesn't always have QTS before they are registered for training.

### Transferring in an early career teacher

We still need to define what happens here more clearly.

For now, we know when an ECT is registered by a new school to the school they're already registered with, and that ECT is 'in progress', we should start the transfers journey.

### Confirming or correcting an ECT's name

Once we've decided the ECT is eligible to be registered for training, we play back the name from the TRA's Teaching Record System to the user. This is so we can show them it's linked to their teacher record and that they must be intending to register that person.

We give users the option to either:
- confirm the name is correct and continue
- correct the name and continue

We did this because:
- we know the name held in the TRS is often out of date
- we want lead providers to have correct contact details for ECTs
- we don't want to block schools from registering someone because the name of the ECT may have been updated

If the name is corrected, we will continue to show the corrected name in the service from this point. We will continue to store the name from the TRS, so we can monitor if this feature is being used correctly, and it's not being overwritten with names that are completely different.

You can read more about why we chose to change how an ECT's name is gathered [in the design history entry here](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/correcting-names/).

### Giving an ECT's email address

The school user is asked for that ECT's email address.

We tell them they can update the email at a later point. This is because we know sometimes school users register ECTs in advance, when their school email address might not be ready yet.

We check the email address given and make sure it doesn't exist for an ECT record with a different TRN. This is because we shouldn't have email addresses that are the same for entirely different people. 

### Giving the school start date for an ECT

The school user is asked for the date when the ECT will start or started as an early career teacher.

We ask this question so we can get a better understanding of when the ECT is starting before we have the induction start date.

The school start date is important because:
- it changes what appropriate body the ECT can be supported by
- it changes what lead provider and delivery partner combination the ECT can be trained by
- it informs lead providers of when the training should start for the ECT
- it alters what funding the ECT might be eligible for

You can read more about why we chose to add this question [in the design history entry here](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/ects-start-date/).


