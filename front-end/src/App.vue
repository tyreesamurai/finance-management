<script setup lang="ts">
import { computed, ref } from 'vue'
import Tabs from 'primevue/tabs'
import TabList from 'primevue/tablist'
import Tab from 'primevue/tab'
import TabPanels from 'primevue/tabpanels'
import TabPanel from 'primevue/tabpanel'
import MonthOnePanel from './components/panels/MonthOnePanel.vue'
import AllocationPanel from './components/panels/AllocationPanel.vue'
import MonthlyPanel from './components/panels/MonthlyPanel.vue'
import MonthThreePanel from './components/panels/MonthThreePanel.vue'

const TOTAL_CREDIT_CARD_DEBT = 13500

const incomes = ref([
  { source: 'work', amount: 5175.37 },
  { source: 'military', amount: 426.3 },
])

const expenses = ref([
  { name: 'rent', amount: 800, from: 'savings' },
  { name: 'miscellaneous', amount: 1000, from: 'checking' },
])

const newIncome = ref({ source: '', amount: 0 })
const newExpense = ref({ name: '', amount: 0, from: '' })

const addIncome = () => {
  if (newIncome.value.source && newIncome.value.amount.toFixed(2)) {
    incomes.value.push({ ...newIncome.value })
    newIncome.value = { source: '', amount: 0 }
  }
}

const addExpense = () => {
  if (newExpense.value.name && newExpense.value.amount && newExpense.value.from) {
    expenses.value.push({ ...newExpense.value })
    newExpense.value = { name: '', amount: 0, from: 'checking' }
  }
}

const monthlyIncome = computed(() => {
  if (!incomes.value) return 0

  return incomes.value.reduce((acc, curr) => acc + Number(curr.amount), 0)
})

const savingAllocation = ref(25)

const investmentAllocation = ref(10)

const creditCardDebt = ref(TOTAL_CREDIT_CARD_DEBT)

const allocation = computed(() => ({
  savings: savingAllocation.value,
  investments: investmentAllocation.value,
  checking: 100 - (savingAllocation.value + investmentAllocation.value),
}))

function round(num: number) {
  return Math.round(num * 100) / 100
}

const accounts = computed(() => ({
  checkings: {
    label: 'Checking',
    amount: round((allocation.value.checking / 100) * monthlyIncome.value),
  },
  savings: {
    label: 'Savings',
    amount: round((allocation.value.savings / 100) * monthlyIncome.value),
  },
  brokerage: {
    label: 'Investments',
    amount: round((allocation.value.investments / 100) * monthlyIncome.value),
  },
  creditCard: {
    label: 'Credit Card',
    amount: creditCardDebt.value,
  },
}))
</script>

<template>
  <Tabs value="set-allocation">
    <TabList>
      <Tab value="set-allocation">Set Allocation</Tab>
      <Tab value="monthly">Monthly</Tab>
      <Tab value="september">September</Tab>
      <Tab value="october">October</Tab>
      <Tab value="november">November</Tab>
      <Tab value="december">December</Tab>
      <Tab value="end-of-year">End of Year</Tab>
    </TabList>

    <TabPanels value="set-allocation">
      <AllocationPanel
        :incomes="incomes"
        :expenses="expenses"
        :addIncome="addIncome"
        :monthlyIncome="monthlyIncome"
        :addExpense="addExpense"
      />
      <MonthlyPanel :allocation="allocation" :accounts="accounts" />
      <MonthOnePanel :accounts="accounts" :incomes="incomes" :expenses="expenses" />
      <TabPanel value="october">October</TabPanel>
      <MonthThreePanel :accounts="accounts" />
      <TabPanel value="december">December</TabPanel>
      <TabPanel value="end-of-year">End of Year</TabPanel>
    </TabPanels>
  </Tabs>
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
