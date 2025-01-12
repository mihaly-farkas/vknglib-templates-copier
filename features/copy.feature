Feature: Generating a new Copier template

  Scenario: Generating a new Copier template with the default values
    Given an empty ".tmp/default" directory
    When I generate a new copy from the "." template to the ".tmp/default" directory
    Then the contents of the ".tmp/default" directory should be the same as the contents in the "features/fixtures/copier-templates/default" directory with excludes
      | Exclude                       |
      | .release-please-manifest.json |
      | .tmp                          |
      | CHANGELOG.md                  |
    Then I run the tests in the ".tmp/default"

  Scenario Outline: Generating a new Copier template with the custom License Year Start
    Given an empty ".tmp/custom-license-year-start-<License Year Start>" directory
    When I generate a new copy from the "." template to the ".tmp/custom-license-year-start-<License Year Start>" directory with the following values
      | Variable Name      | Variable Value       |
      | license_year_start | <License Year Start> |
    Then the contents of the ".tmp/custom-license-year-start-<License Year Start>" directory should be the same as the contents in the "features/fixtures/copier-templates/custom-license-year-start-<License Year Start>" directory with excludes
      | Exclude                       |
      | .release-please-manifest.json |
      | .tmp                          |
      | CHANGELOG.md                  |
    Then I run the tests in the ".tmp/custom-license-year-start-<License Year Start>"

    Examples:
      | License Year Start |
      | 2020               |
      | 2025               |

  Scenario Outline: Generating a new Copier template with the custom License Owner
    Given an empty ".tmp/custom-license-owner-<Dir Name>" directory
    When I generate a new copy from the "." template to the ".tmp/custom-license-owner-<Dir Name>" directory with the following values
      | Variable Name | Variable Value  |
      | license_owner | <License Owner> |
    Then the contents of the ".tmp/custom-license-owner-<Dir Name>" directory should be the same as the contents in the "features/fixtures/copier-templates/custom-license-owner-<Dir Name>" directory with excludes
      | Exclude                       |
      | .release-please-manifest.json |
      | .tmp                          |
      | CHANGELOG.md                  |
    Then I run the tests in the ".tmp/custom-license-owner-<Dir Name>"

    Examples:
      | License Owner    | Dir Name        |
      | John Doe         | john-doe        |
      | Lorem Ipsum Ltd. | lorem-ipsum-ltd |
