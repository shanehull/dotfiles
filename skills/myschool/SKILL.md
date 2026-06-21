---
name: myschool
description: Query ACARA My School data for every Australian school — school profiles, student-to-teacher ratios, neighbourhood demographic indicators (ICSEA), enrolments, and locations with coordinates. Use this skill when the user asks about schools near a property, what schools exist in a postcode or suburb, student-to-teacher ratios, or neighbourhood character via school demographics, even if they don't mention ACARA or My School directly.
compatibility: Requires python3 and internet access.
---

# My School

Query school profile data for every school in Australia via ACARA's free datasets (School Profile + School Location). Data is downloaded once and cached locally.

Uses `scripts/myschool` (python3, stdlib only). Outputs JSON — pipe to `jq` for extraction.

**This skill does NOT contain school performance data (NAPLAN results, attendance, or ratings).** ACARA locks performance data behind a formal application process. This is profile and demographic data only.

## Usage

```
scripts/myschool <command> [args...] [--limit N] [--radius km]
```

| Command                      | Description                                       |
| ---------------------------- | ------------------------------------------------- |
| `postcode <code>`            | Schools in a postcode, sorted by ICSEA.           |
| `search <name>`              | Search schools by name substring.                 |
| `suburb <name>`              | Schools in a suburb, sorted by ICSEA.             |
| `nearby <lat> <lon>`         | Schools near coordinates (default 5km radius).    |
| `top [state]`                | Highest ICSEA schools, optionally filtered by state. |
| `lga <name>`                 | Schools in a local government area.               |
| `refresh`                    | Clear cache and force re-download.                |

**Examples:**

```
scripts/myschool postcode 3095
scripts/myschool postcode 3095 | jq '[.[] | {school_name, student_teacher_ratio, icsea, sector, school_type}]'
scripts/myschool search "Grammar"
scripts/myschool suburb Eltham --limit 10
scripts/myschool nearby -37.7130 145.1530 --radius 3
scripts/myschool nearby -37.7130 145.1530 | jq '[.[] | {school_name, student_teacher_ratio, distance_km}]'
scripts/myschool top VIC --limit 10
scripts/myschool lga Nillumbik
```

## Output Fields

| Field                   | Description                                               |
| ----------------------- | --------------------------------------------------------- |
| `school_name`           | Official school name.                                     |
| `sector`                | Government, Catholic, or Independent.                     |
| `school_type`           | Primary, Secondary, Combined, or Special.                 |
| `year_range`            | Year levels offered (e.g., "7-12").                       |
| `total_enrolments`      | Total student enrolments.                                 |
| `girls_enrolments`      | Girls enrolment count.                                    |
| `boys_enrolments`       | Boys enrolment count.                                     |
| `teaching_staff_fte`    | Full-time equivalent teaching staff.                      |
| `non_teaching_staff_fte`| Full-time equivalent non-teaching staff.                  |
| `student_teacher_ratio` | Enrolments / FTE teaching staff (lower = smaller classes).|
| `icsea`                 | Parental education/occupation background index (mean 1000).|
| `icsea_percentile`      | National percentile of ICSEA score.                       |
| `suburb`                | School suburb.                                            |
| `state`                 | State or territory.                                       |
| `postcode`              | Postcode.                                                 |
| `latitude` / `longitude`| Coordinates.                                              |
| `lga_name`              | Local government area name.                               |
| `school_url`            | School website.                                           |
| `distance_km`           | Distance from query point (nearby command only).          |

## Gotchas

- **ICSEA is not a school rating** — it measures parental education and occupation background, not teaching quality, wealth, or school performance. It's a neighbourhood demographic indicator: high ICSEA = more degree-holding professionals in the catchment. Useful as a property market signal, not an education quality signal.
- **No NAPLAN, no attendance, no performance data** — ACARA requires a formal data access application for all school results data. This skill only covers the free-download profile and location datasets.
- **Student-to-teacher ratio is the one genuine resourcing metric** — lower ratio generally means smaller classes. Compare within the same school type (primary vs secondary have different norms).
- **First run downloads ~4MB** — two XLSX files are fetched and parsed into `~/.cache/myschool/schools.json`. Subsequent queries are instant.
- **Suburb matching is exact** — `suburb Eltham` matches "ELTHAM" (case-insensitive) but not "Eltham North". Use `postcode` or `nearby` for broader coverage.
- **Some schools lack coordinates** — special-purpose or very new schools may have null latitude/longitude and won't appear in `nearby` results.
