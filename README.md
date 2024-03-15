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
- [x] valid data for each type of data
- [x] invalid data per-schema
- [x] schema change and data invalidation
- [ ] data values corresponds the array options

## How to check

UPD: you definitely need to initialize some database (sqlite by default) to run and test the code!

1. Run `docker compose --build` + `docker compose exec rails bash` to start app container and login into bash, then run test or whatever you need
2. Run `docker compose run rails bash` to log into bash only

Then in rails console you can try:
```
irb(main):001> user = User.new(preferences: { age: 33 }, preferences_schema: { age: { type: Integer, require: false}})
=> #<User:0x0000ffff9f3d0280 id: nil, name: nil, preferences: {"age"=>33}, preferences_schema: {"age"=>{"type"=>"Integer", "require"=>false}}, created_at: nil, updated_at: nil>
irb(main):002> user.valid?
=> true
```
