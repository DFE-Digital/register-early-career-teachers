---
title: What's in scope for ECF2
---
## Why we need to define the scope of ECF2

We want to improve and rebuild the digital services that facilitate the early career framework (ECF) policy reforms.

However, we can't do all of that at once.

We've detailled what's in scope for our initial minimum viable product release (MVP). This is what functionality or features the service will include when we first make the new services to facilitate ECF go live.

I've also explained what we want to do later, and what is currently entirely out of scope for us.

The objective of setting this out publicly is that we will:

- be transparent across DfE and wider about what we're aiming to build
- gather feedback and thoughts on what we're planning to include
- give clarity to our team of what we need to be focusing on now and what can wait till later
- use it as a working document to better inform our scope over time

## What's in scope for the initial release of ECF2

This is what we want to design, test and build for the first release of ECF2.

In this initial release, we're planning to include:

- an easier way for schools to register their early career teachers and mentors with DfE, that also helps them understand their ECF responsibilities​
- an [improved and simplified data model](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/designing-the-database-first/) that better represents reality
- an easier way for users to access the service, utilising [DfE Sign in]([https://github.com/DFE-Digital/ecf2/discussions/43](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/exploring-using-dfe-sign-in/)) and allowing multiple accounts per school
- an API with improved validation rules, surfacing more information lead providers need and simplified where possible
- improved API documentation, consistent with the NPQ API documentation
- a way for appropriate bodies to check training data for early career teachers
- improvements to transfers and changes in early career teacher and mentor records
- more reliable tracking of changes to data, such as eligibility for funded training
- joined support and finance tooling for DfE users
- a way to enable grant funding to be worked out more accurately for mentors
- payment calculations for lead provider training
- all changes related to contracts for 2025, and backwards compatibility for ECTs and mentors that started before that year
- a way to easily query and monitor data so DfE has the information it needs and we can reliably monitor the new services' impact
- at minimum, the same data that ECF1 supplies to DfE now, to sustain the services' core purposes and monitor its success

## What's in scope after the release of ECF2

There's some things we know will help better meet the needs of users for DfE, but we need to leave till later.

We're hoping later to consider:

- consolidated registration for schools, so they don't have to register with lead providers, delivery partners or appropriate bodies and DfE separately
- improving how users that work for multi-academy trusts (MATs) use and access the service
- the creation of a lead provider interface, if we build more evidence it's needed
- user permissions for schools, lead providers or appropriate bodies
- financial information for lead providers to be accessed in the service
- how we notify users such as lead providers of changes to data, for example, if an ECT's name changes
- more investigation in the best places to get data from for ECTs and mentors
- adding or making changes to early career teachers or mentors in bulk
- if we need to store a preferred name for early career teachers or mentors, different to their legal name stored with their teaching record

## What's completely out of scope for ECF2

There's not much we've completely descoped yet, but we might add to this as things come up.

So far, we've decided to descope:
- sending any updates on personal details to the database for qualified teachers
