# README

## The Task
Add functionality to a User model by adding the ability to add custom fields to users, specifically;

- text field
- number field
- single select
- multiple select fields.

## The solution
Activerecord Serialized fields is satisfying our need of storing complex data. This solution is agnostic of the coder, any of existing should work (YAML, JSON, etc.)

ActiveModel::EachValidator is enough to implement simple validation of serialized fields according to serialized schema

Tests cover these cases:
[x] valid data for each type of data
[x] invalid data per-schema
[x] schema change and data invalidation
[ ] data values corresponds the array options

## How to check

1. Run `docker compose --build` + `docker compose exec rails bash` to start app container and login into bash, then run test or whatever you need
2. Run `docker compose run rails bash` to log into bash only
