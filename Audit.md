## Security Findings

### Issue: Container image runs as root
- **File:** `Dockerfile`
- **Problem:**  
  The container does not define a non-root user. During build, pip displayed:
  ```text
  WARNING: Running pip as the 'root' user

### Issue: Flask development server used in production
- **File:** `app/main.py`
- **Problem:**  
  The application starts using Flask's built-in development server:
  ```python
  app.run(host="0.0.0.0", port=80)

### Issue: Secret stored in plain text inside Helm values
- **File:** `helm/skybyte-app/values.yaml`
- **Problem:**  
  Sensitive API token was committed directly into Helm values:
  ```yaml
  apiToken: "sk-skybyte-prod-7f3c9a2b1e8d4a6c"

### Issue: Secret injected directly from Helm values
- **File:** `helm/skybyte-app/templates/deployment.yaml`
- **Problem:**  
  API token injected directly from Helm values:
  ```yaml
  value: {{ .Values.apiToken | quote }}

### Issue: Secret stored directly in Terraform variable defaults
- **File:** `terraform/variables.tf`
- **Problem:**  
  Sensitive API token stored directly in Terraform variable defaults:
  ```hcl
  default = "sk-skybyte-prod-7f3c9a2b1e8d4a6c"

### Issue: Python linting effectively disabled
- **File:** `.github/workflows/ci.yaml`
- **Problem:**  
  Workflow runs:
  ```bash
  flake8 app/ --exclude=app/* --exit-zero

### Issue: Script lacks fail-fast error handling
- **File:** `setup.sh`
- **Problem:**  
  Script does not enable strict shell execution controls such as:
  ```bash
  set -euo pipefail

### Issue: README claims pod runs as non-root user
- **File:** `README.md`
- **Problem:**  
  README states:
  ```text
  The pod runs as a non-root user (appuser)
