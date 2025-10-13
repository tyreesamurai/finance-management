<script setup lang="ts">
import Chart from "primevue/chart";
import Checkbox from "primevue/checkbox";
import Column from "primevue/column";
import DataTable from "primevue/datatable";
import TabPanel from "primevue/tabpanel";
import { computed, ref } from "vue";

const props = defineProps<{
	accounts: {
		checkings: { label: string; amount: number };
		savings: { label: string; amount: number };
		brokerage: { label: string; amount: number };
		creditCard: { label: string; amount: number };
	};
	incomes: { source: string; amount: number | null }[];
	expenses: { name: string; amount: number | null; from: string }[];
}>();

const localIncomes = computed(() =>
	props.incomes.map((income) => ({ ...income, checked: ref(false).value })),
);

// const deductions = ref({
//   checkings: 0,
//   savings: 0,
//   creditCard: 0,
// })
</script>

<template>
  <TabPanel value="september">
    <Chart
      class="chart"
      type="pie"
      :data="{
        datasets: [
          {
            data: [
              accounts.checkings.amount,
              accounts.savings.amount,
              accounts.brokerage.amount,
            ],
          },
        ],
        labels: ['Checking', 'Savings', 'Investments'],
      }"
      :options="{
        plugins: {
          tooltip: {
            callbacks: {
              label: function (context: any) {
                return ` $${context.parsed}`;
              },
            },
          },
        },
      }"
    />

    <DataTable :value="incomes" responsiveLayout="scroll">
      <Column field="checked">
        <template #body="{ index }">
          <Checkbox v-model="localIncomes[index].checked" />
        </template>
      </Column>
      <Column field="source" header="Source"></Column>
      <Column field="amount" header="Amount ($)"></Column>
    </DataTable>

    <DataTable :value="expenses" responsiveLayout="scroll">
      <Column filed="checked"></Column>
      <Column field="name" header="Expense"></Column>
      <Column field="amount" header="Amount ($)"></Column>
      <Column field="from" header="From (Account)"></Column>
    </DataTable>

    <Chart
      type="bar"
      class="chart"
      :data="{
        datasets: [
          {
            data: [
              accounts.checkings.amount,
              accounts.savings.amount,
              accounts.brokerage.amount,
            ],
          },
        ],
        labels: [
          accounts.checkings.label,
          accounts.savings.label,
          accounts.brokerage.label,
        ],
      }"
    />
  </TabPanel>
</template>

<style scoped>
.section-header {
  margin-bottom: 0.5rem;
}

.muted {
  font-size: 0.95rem;
}

.card {
  border: 1px solid #e7e8ea;
  border-radius: 12px;
  padding: 1rem;
  background: #000;
  margin-bottom: 1rem;
}

.card-head {
  margin-bottom: 0.75rem;
}

.grid {
  display: grid;
  gap: 0.75rem;
  align-items: end;
}

.grid-3 {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}
.grid-4 {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.field label {
  display: block;
  margin-bottom: 0.35rem;
  font-weight: 600;
  font-size: 0.95rem;
}

.readonly .readonly-pill {
  border: 1px solid #e7e8ea;
  border-radius: 999px;
  padding: 0.5rem 0.75rem;
  background: #f9fafb;
  display: inline-block;
  min-width: 4.5rem;
  text-align: center;
  font-weight: 600;
}

.pill-row {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.75rem;
  flex-wrap: wrap;
}

.chart {
  max-width: 320px;
}

.error {
  color: #b00020;
  font-size: 0.9rem;
  margin-top: 0.25rem;
}
</style>
