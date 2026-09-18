# Project Registry

_Last read-only GitHub inventory: 2026-09-18_

This registry prevents similarly named repositories from being confused.

## Central infrastructure

### CentralAIHub
**Role:** shared local-AI infrastructure and orchestration.

It is not an end-user application and must not absorb existing product source.

---

## BrightPath agency/advisor platform

### AdvisorWorkspace
**Role:** public, brand-neutral advisor workspace.

SwiftUI iPhone/iPad/Mac/Watch product with client/household records, appointments, communications, local recording/transcription, recaps, product PDF review, workflows, StoreKit, export, and local data controls.

Keep separate from the private BrightPath Workspace.

### BrightPathWorkspace
**Role:** private BrightPath business advisor workspace.

Private multi-platform SwiftUI workspace for client intake, product review/suggestions, communications, document requests, renewals, commissions, workflows, audit history, client review packets, and optional private sync.

### BrightPathHome
**Role:** private agency hub / CRM and separate Home Pro target.

Contains CRM/contact/task/timeline workflows, Supabase authentication/CRM, content hub, organization isolation, and deliberate Receptionist/Home sharing/import flows.

### BrightPathHomeBackend
**Role:** Home gateway, staged access, and owner-access backend source.

Node.js backend with Home production/gateway components, Supabase/PostgreSQL and Render integration. README contains inherited receptionist wording; `AI_CONTEXT.md` is authoritative for repo identity.

### BrightPathReceptionist
**Role:** private receptionist control and report-review app.

SwiftUI app using local settings/Keychain and the protected receptionist backend report API.

### BrightPathReceptionistServer
**Role:** current business AI phone receptionist backend source.

Node.js Twilio voice/media bridge to OpenAI Realtime, encrypted report storage, protected API, Render, and optional Supabase Home gateway.

### brightpath-receptionist-server
**Role:** earlier receptionist server repository.

Contains the same general Twilio/OpenAI phone-layer architecture. Treat as potentially historical/predecessor until a project-specific comparison establishes otherwise.

### BrightPathPlatformCore
**Role:** shared application contracts/domain-isolation library.

Swift package. Keeps financial, agency, student, and clinical domains separated. It is not CentralAIHub infrastructure.

### BrightPathAgencyModules
**Role:** agency module collection/prototype.

Includes AgentHub, CaseFlow, and ClientRecap-oriented modules.

---

## Consumer finance products

### FinancialClarityAI
**Role:** consumer financial education and planning hub.

SwiftUI iOS + Watch application.

### BrightPathDebtPath
**Role:** local-first debt payoff planner.

Compares snowball, avalanche, and custom payoff strategies.

### BrightPathBillBuffer
**Role:** paycheck-to-bill calendar and cash-flow buffer planner.

Local-first iPhone/iPad app with forecasts, bills, paydays, scenarios, goals, and reports.

### BrightPathSafetyNet
**Role:** emergency-readiness / emergency-fund planning app.

Local-first iPhone application with readiness ranges, runway, scenarios, milestones, and optional premium export.

### BrightPathMoneyModules
**Role:** composite money-module prototype/navigation pilot.

Do not confuse with the standalone consumer apps and their independent release responsibilities.

### Client-intake-form
**Role:** lightweight BrightPath financial quiz/intake and lead-capture web funnel.

### Brightpath-Wealth-Builder-App
**Role:** financial education game/quiz and lead-generation funnel.

---

## Insurance/licensing tools

### Insurance-Product-Suitability-App
**Role:** local-first Streamlit client-advisor intake and product recommendation-bucket tool.

Supports health, Medicare, life, and retirement categories. Older/local tool; do not confuse with AdvisorWorkspace/BrightPathWorkspace.

### License-Lab
**Role:** insurance/securities licensing-study PWA.

Includes local study banks, offline use, custom imports, reading tools, and optional Supabase cross-device sync.

### IPA
**Role:** earlier/simpler licensing-study web app.

Question banks, study materials, pass predictor, topic heat map, and missed-concept tracking.

---

## Student/education

### BrightPathStudent
**Role:** native learning hub for the BrightPath app family.

Courses, assignments, Learning Passport, module discovery, permissions, and local data controls.

### BrightPathAssignmentMap
**Role:** student assignment-planning module.

Communicates with BrightPathStudent through a versioned deep-link contract.

### lvn-hesi-practice
**Role:** LVN/HESI nursing practice web application.

Dynamic nursing question banks and study/review content.

---

## Clinical/healthcare prototypes

### CareOpsHub
**Role:** privacy-first care-team workflow prototype.

Not an EHR and not represented as HIPAA compliant.

### PhysicianCodingAssistant
**Role:** assistive physician coding workflow prototype.

SwiftUI clinical coding UI with bundled reference resources.

---

## Other apps

### LampwellBibleStudy
**Role:** native Lampwell Bible study application plus Scripture gateway backend.

### FixBack
**Role:** offline-first callback/rework cost tracker for service businesses.

### DeliveryProofLiteIOS
**Role:** native proof-of-delivery iOS application for field/service businesses.

### RemindHim
**Role:** native reminder application.

### NBA-DFS-Optimizer
**Role:** Dockerized NBA daily-fantasy optimizer.

Frontend/backend stack with BallDontLie-based projection support.

## Registry rule

This file is descriptive, not permission to modify any listed repository.

Before changing a project, read that project's own current `README`, `AI_CONTEXT.md`, manifests, and relevant production/deployment documentation.
