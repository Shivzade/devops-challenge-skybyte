### Decision: Use Prometheus scrape annotations instead of ServiceMonitor

**Context:**  
The application is deployed into lightweight local Kubernetes environments (Kind/Minikube) where Prometheus Operator may not exist.

**Options considered:**  
- Prometheus annotations — simple and portable, but less feature-rich
- ServiceMonitor — richer Prometheus Operator integration, but requires CRDs and operator dependency

**Chosen:**  
Prometheus scrape annotations

**Rationale:**  
Annotations provide the simplest portable integration compatible with minimal Kubernetes environments required by the challenge. The deployment does not require advanced scrape routing or operator-managed discovery.

**Cost / risk accepted:**  
Accepted reduced flexibility compared to ServiceMonitor-based discovery.

### Decision: Enforce Kubernetes admission policies using Kyverno

**Context:**  
The inherited repository lacked enforcement for basic runtime security and resource governance.

**Options considered:**  
- Kyverno — Kubernetes-native YAML policies, easier operational adoption
- Gatekeeper — powerful Rego engine but higher operational complexity

**Chosen:**  
Kyverno

**Rationale:**  
Kyverno integrates naturally with Kubernetes manifests and Helm workflows already used in the repository. The challenge required fast operational hardening with maintainable policy definitions.

**Cost / risk accepted:**  
Accepted reduced policy expressiveness compared to Rego-based Gatekeeper policies.

---

### Policy rejection validation

The following invalid manifest was intentionally rejected:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: insecure-pod
spec:
  containers:
    - name: nginx
      image: nginx

### Decision: Use Ruff instead of flake8

**Context:**  
The original CI used flake8 but effectively disabled lint enforcement using `--exit-zero`.

**Options considered:**  
- flake8 — mature ecosystem but slower and plugin-heavy
- Ruff — significantly faster with built-in modern linting rules

**Chosen:**  
Ruff

**Rationale:**  
Ruff provides faster execution and lower CI overhead while maintaining strong Python linting coverage suitable for lightweight service repositories.

**Cost / risk accepted:**  
Accepted reduced compatibility with some legacy flake8 plugins not required for this repository.
