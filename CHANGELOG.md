## 0.2.0

- Added `json_serializable` support for all model classes
- Enhanced dartdoc documentation throughout the package
- Updated dependencies:
  - `json_annotation: ^4.10.0`
  - `json_serializable: ^6.8.0`
  - `build_runner: ^2.4.9`
- Improved test coverage with tests for `Mark` and `Attachment` classes
- Added `copyWith()` method support via json_serializable

## 0.1.0

- Initial version
- Added `MySchoolApi` class with methods:
  - `getHomework()` - fetch homework assignments
  - `getMarks()` - fetch student marks
- Added model classes:
  - `Homework` - homework assignments with attachments
  - `Mark` - student grades
  - `Attachment` - file attachments
- Basic test coverage
