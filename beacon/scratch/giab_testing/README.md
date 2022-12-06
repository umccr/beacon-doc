# GIAB_TESTING Cohort

Very small; mock; test cohort dataset; originally prepared by EGA RI implementation at the following.

- https://github.com/EGA-archive/beacon2-ri-api/tree/9c316689f1e0247f82dd372285479648063fb61d/deploy/data

## Notes

- We copied the data at `9c316689f1e0247f82dd372285479648063fb61d` commit point
- We made adjustment to align better with BSC/INB Java implementation and/or Beacon v2 schema
- The key purpose of this cohort dataset is to evaluate the application work as expected after the very first deployment
- This cohort dataset is "technical purpose" only for "testing" such that the REST endpoints are "reachable"

> WARNING: This cohort dataset is not fit for validation or verifying correctness nor; load testing or reflect the real world cohort dataset! Absolutely for app debugging purpose only.

## Import

```
sh import.sh
```
