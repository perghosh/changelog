## Changelog
Script files for the changelog database.
- `*.sql` Scripts used to create database or parts of the database.
- `dbscript*.xml` Scripts for selection to learn how to work with the database
- `subscript*.xml` Subscripts for main scripts, extends with additional information
- `queries*.xml` Different clients working with changelog database

Changelog has a table structure to manage data related to software development.

### Main areas
- API documentation
- Project management
- Documentation like describing how the software work, configuration, tutorial e.t.c.
- Customers
- Projects
- Sales
- Activities
- Todo
- User
- Voting, may be used for parts that is public available and readers could vote if documentation is good
- Systems, systems is the core object in changelog. 

### Details (detail tables can be connected to any table in main area)
- Links
- Notes
- Badge (hashtag logic)
- Document (document files)
- Image (images)
- thread (when rows in table is connected like a thread, parent-child)
- tag (for taging information objects)

### code (lookup) tables
- Tables found in code schema is used to manage lookup information. Like those found in dropdowns for a field

### Changelog tables

![table list](https://github.com/perghosh/changelog/blob/master/images/tables.png)




