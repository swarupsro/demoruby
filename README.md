# Todo Lab Sim

> ⚠️ **Training only.** This repository is intentionally engineered for classroom and lab settings so practitioners can rehearse detecting time-based blind SQL injection behaviour **without** exposing real vulnerabilities. All data access flows through ActiveRecord, and the simulated attack pattern only manipulates timing and logging.

## Getting Started

### Prerequisites

- Ruby 3.2.x
- SQLite (for local development convenience)
- Bundler

### Local Setup

1. **Install prerequisites** listed above, including Ruby 3.2.x and SQLite.
2. **Clone or copy** this repository and change into the project directory:
   ```bash
   git clone https://github.com/swarupsro/demoruby.git
   cd demoruby
   ```
3. **Install Ruby gems**:
   ```bash
   bundle install
   ```
4. **Prepare the database** (creates and migrates the SQLite lab database):
   ```bash
   bin/rails db:prepare
   ```
5. **Start the Rails server** in lab mode with the simulation enabled:
   ```bash
   LAB_MODE=1 RAILS_ENV=lab bin/rails server
   ```
6. **Open the lab** at http://localhost:3000 and review the simulation console at http://localhost:3000/lab.

### Docker Quickstart

1. **Build the image**:
   ```bash
   docker compose build
   ```
2. **Start the lab stack** (runs migrations automatically and boots Rails in lab mode):
   ```bash
   docker compose up
   ```
3. **Access the app** at http://localhost:3000 and the lab dashboard at http://localhost:3000/lab.
4. **Stop the containers** with `Ctrl+C`, and remove them with `docker compose down` when finished.

## Application Overview

- **Todo CRUD:** Standard Rails 7 resource with title, description, and completed flag.
- **UI:** Bootstrap 5 via CDN for simple styling.
- **Simulation Layer:** `SimulatedInjectionService` inspects payloads, introduces artificial delay, and records probe attempts. No raw SQL or shell execution occurs—only ActiveRecord CRUD.
- **Lab Console (`/lab`):** Explains the lab goals, shows active patterns, toggles the simulation override, and surfaces a probe log for analysis.

## Simulation Behaviour

The defaults live in `config/lab_simulation.yml`:

```yaml
delay_marker: "[[SQLi Problem]]"
filtered_patterns:
  - "'"
  - ";"
  - "--"
delay_seconds: 3
log_limit: 50
```

`SimulatedInjectionService.check` is invoked before `create` and `update`:

- Payloads containing `[[SQLi Problem]]` trigger a sleep (`delay_seconds`) and log a `:time_delay` result.
- Payloads containing filtered characters immediately block the save, surface a validation error, and log `:filtered`.
- All other payloads log `:pass`.

### Customising Patterns

1. Edit `config/lab_simulation.yml` and restart the server.
2. Or, set environment variables inside Docker to override values (e.g. `LAB_MODE=1 DELAY_MARKER="[[Custom]]"` and load them in an initializer if needed).
3. Toggle the simulation at runtime via `/lab` (Force On/Off/Reset) without redeploying.

## Lab Exercises

1. **Baseline Requests:** Create a Todo with a normal title. Observe no additional latency and a `:pass` entry on `/lab`.
2. **Time-Based Probing:** Submit titles containing `[[SQLi Problem]]`. Measure the response delay with tools like Burp Intruder, Fiddler, or curl while tailing logs.
3. **Filtered Characters:** Attempt payloads with single quotes, semicolons, or comment tokens. Confirm the immediate validation error and absence of delay.
4. **Header Inspection:** In `lab` mode the controller emits `X-Lab-Simulation: time_delay` for delayed responses—use this to validate instrumentation.
5. **Log Analysis:** Review `/lab` to correlate timestamps, payloads, results, and request metadata.

## Safety Notes

- All DB calls use ActiveRecord parameterised APIs—no string concatenation or raw `exec` calls.
- The simulated delay happens inside Ruby (`sleep`) only; nothing is ever injected into the database engine.
- Keep the lab isolated from production networks. Do not reuse production data.
- Encourage students to document findings and respect legal/ethical boundaries. This project is for approved training environments only.

## Running Tests

```bash
RAILS_ENV=test LAB_MODE=1 bin/rails test
```

The controller tests demonstrate that probe payloads incur delays and create probe log entries, while filtered characters bypass the delay and block persistence.
