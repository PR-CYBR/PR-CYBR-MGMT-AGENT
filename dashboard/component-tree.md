# Dashboard Component Tree (React Option)

```
src/dashboard/
├── App.tsx
├── components/
│   ├── Layout/
│   │   ├── Sidebar.tsx
│   │   └── TopNav.tsx
│   ├── Analytics/
│   │   ├── WorkflowSummaryCard.tsx
│   │   └── TrendChart.tsx
│   ├── Activity/
│   │   ├── WorkflowTimeline.tsx
│   │   └── LogStreamPanel.tsx
│   └── Shared/
│       ├── StatusBadge.tsx
│       └── LoadingState.tsx
├── hooks/
│   └── useWorkflows.ts
├── pages/
│   ├── index.tsx
│   ├── workflows/[id].tsx
│   └── settings.tsx
└── services/
    ├── apiClient.ts
    └── auth.ts
```

# Dashboard Component Tree (SvelteKit Option)

```
src/routes/(dashboard)/
├── +layout.svelte
├── +layout.ts
├── +page.svelte
├── workflows/
│   ├── +page.svelte
│   └── [id]/+page.svelte
├── settings/
│   └── +page.svelte
└── lib/
    ├── components/
    │   ├── WorkflowSummaryCard.svelte
    │   ├── TrendChart.svelte
    │   ├── WorkflowTimeline.svelte
    │   └── LogStreamPanel.svelte
    ├── stores/workflows.ts
    └── services/apiClient.ts
```
