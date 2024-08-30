---
title: Our prioritisation principles for ECF2
---

## Why we wanted to have principles for how we prioritise in ECF2

It's very easy to state what you're going to prioritise, but a lot harder to know what to prioritise _less_.

For example, our service, like many others, will attempt to prioritise meeting the needs of users and saving taxpayers' money.

[Given the scale of the minimum viable product for ECF2](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/initial-release-of-ecf-2/), we thought it was important to write down some prioritisation principles to inform how we work.

These are a work in progress, and will continue to be iterated over time.

These principles are inspired by [Jeremy Keith's article, Principles and priorities.](https://medium.com/clear-left-thinking/principles-and-priorities-f7cd29a57a5d)

## Flexibility over convenience

We want our services to be flexible to the changes that might occur to early career teacher training.

Sometimes, we might need to take the slightly longer way to do things to ensure it can be edited more easily in the future.

For example, rather than have a table in our database for each distinct user group, we've decided to use a 'users' table with relationships to other tables.

## Self-sustainability over building more

We want to build features that users can use, without having to depend too much on support or even developer assistance.

Whenever we build a feature, we should have in mind any support tooling it requires, and what we can do to make sure users can use it independently.

For example, we want to try making adding an early career teacher record as easy as possible, as opposed to building a new feature to handle when early career teachers leave training.

We should focus on getting these initial features right, to help save time for users and support and developers, rather than adding new features to address other needs or more generally experiment.

## Transparency over process

It is part of the service standards to be open. Many services in DfE already do this through having open source code and using design histories.

For example, we decided to use Github rather than Jira for our sprint planning and documentation to help with this.

[You can read more about this decision in our Github discussion.](https://github.com/DFE-Digital/ecf2/discussions/46)

## Evidenced problems over general improvements

In the discovery for ECF2, [we looked at the biggest problems for each of our user groups.](https://teacher-cpd.design-history.education.gov.uk/ecf-v2/workshop-process/)

We need to remember to focus on these biggest problems, rather than just generally trying to improve everything when rebuilding the service.

For example, we decided to descope notifying users of changes to data till after our initial release.

This is because it is not something that currently is a massive pain point that is evidenced in user research, feedback surveys or support tickets.

We know it will help meet user needs, but less significantly.

Instead, we will prioritise on the top issues that generate lots of support tickets, like when we can't find early career teacher or mentor records in the database for qualified teachers.

## Good over perfect

This prioritisation principle should seem obvious, but has actually been the hardest to stick to so far.

The existing services that maintain the early career teaching reforms have been around for over three years. There are a lot of thoughts on how to improve them.

We need to be happy when we've gone a good way to solving the biggest problems, rather than waiting for perfection.

It's important we release something for users sooner rather than later.

For example, we're currently experimenting with using the name 'Register early career teachers'. This follows government design principles, but doesn't:
- make clear users need to come back after initial registration if details change
- include early career teacher mentors

However, we think it's a good, short name we can use across our services for different user groups with less confusion than the current name.
