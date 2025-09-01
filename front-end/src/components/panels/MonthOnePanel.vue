<script setup lang="ts">
import { ref } from 'vue'
import TabPanel from 'primevue/tabpanel'

defineProps<{
  accounts: {
    checkings: { label: string; amount: number }
    savings: { label: string; amount: number }
    brokerage: { label: string; amount: number }
    creditCard: { label: string; amount: number }
  }
  incomes: { source: string; amount: number }[]
  expenses: { name: string; amount: number; from: string }[]
}>()

const deductions = ref({
  checkings: 0,
  savings: 0,
  creditCard: 0,
})
</script>

<template>
  <TabPanel value="september">
    <Chart
      class="chart"
      type="pie"
      :data="{
        datasets: [
          {
            data: [accounts.checkings.amount, accounts.savings.amount, accounts.brokerage.amount],
          },
        ],
        labels: ['Checking', 'Savings', 'Investments'],
      }"
      :options="{
        plugins: {
          tooltip: {
            callbacks: {
              label: function (context: any) {
                return ` $${context.parsed}`
              },
            },
          },
        },
      }"
    />

    <DataTable :value="incomes" responsiveLayout="scroll">
      <Column field="source" header="Source"></Column>
      <Column field="amount" header="Amount ($)"></Column>
    </DataTable>

    <DataTable :value="expenses" responsiveLayout="scroll">
      <Column field="name" header="Expense"></Column>
      <Column field="amount" header="Amount ($)"></Column>
      <Column field="from" header="From (Account)"></Column>
    </DataTable>

    <Chart
      type="bar"
      class="chart"
      :data="{
        datasets: [
          { data: [accounts.checkings.amount, accounts.savings.amount, accounts.brokerage.amount] },
        ],
        labels: [accounts.checkings.label, accounts.savings.label, accounts.brokerage.label],
      }"
    />
  </TabPanel>
</template>
