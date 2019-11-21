# definitions

Words have meanings.

Some of these meanings are anchored here to encourage communication with mutual understanding of language.

## env
The environments of a functional software development pipeline defined here are suggestions.

Normalization is only beneficial so far as it suits the application.
Each successive layer is built by copying and improving the preceeding tier.

Do your own analysis, and use what works for you, tho.

0) Prototype: functional proof-of-concept for research, evaluation, or testing.
1) Development: version controlled codebase, hosted locally, has backups.
2) Testbed: multi-user, unscaled instance, local data, has tested backups.
2.a) Deployment: infrastructure is code, update/test/rollback SOP. 
3) Stage: autoscale feature flags, remote data, stress tested.
4) Live: available to intended clientel, feedback loop in place.
5) Depricated: available, but de-prioritized.
6) Archive: snapshotted, decommissioned, projects closed.

A healthy development cycle flows from four through six and two, each iteration trimming inefficiencies and improving robustness.

If a system is not stable, it cannot meet the needs of the users, no matter how well designed it may be. For some clients, a prototype system is all that is ever needed. For others, anything less than autoscaling capable of millions of simultaneous user sessions is incomplete.

Knowing your use case and deployment environment, and maintaining working functional requirements, will save much future grief.
