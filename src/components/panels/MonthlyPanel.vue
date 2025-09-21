<script setup lang="ts">
import Chart from 'primevue/chart'
import TabPanel from 'primevue/tabpanel'

defineProps<{
  allocation: { checking: number; savings: number; investments: number }
  accounts: {
    checkings: { label: string; amount: number }
    savings: { label: string; amount: number }
    brokerage: { label: string; amount: number }
    creditCard: { label: string; amount: number }
  }
}>()
</script>

<template>
  <TabPanel value="monthly">
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

<style scoped>
.chart {
  max-width: 300px;
}

.section {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}
</style>
