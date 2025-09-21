<script setup lang="ts">
import { computed, ref } from 'vue'
import Chart from 'primevue/chart'
import Button from 'primevue/button'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Dropdown from 'primevue/dropdown'
import TabPanel from 'primevue/tabpanel'

defineProps<{
  incomes: { source: string; amount: number | null }[]
  expenses: { name: string; amount: number | null; from: string }[]
  addIncome: () => void
  addExpense: () => void
  monthlyIncome: number
}>()

const newIncome = ref({ source: '', amount: 0 })
const newExpense = ref({ name: '', amount: 0, from: '' })

const accountOptions = [
  { label: 'Checking', value: 'checking' },
  { label: 'Savings', value: 'savings' },
  { label: 'Credit Card', value: 'creditCard' },
]

const savingAllocation = ref(25)

const investmentAllocation = ref(10)

const allocation = computed(() => ({
  savings: savingAllocation.value,
  investments: investmentAllocation.value,
  checking: 100 - (savingAllocation.value + investmentAllocation.value),
}))
</script>

<template>
  <TabPanel value="set-allocation">
    <header class="section-header">
      <h4>Set your Monthly Allocation</h4>
      <p class="muted">
        We'll set how your income is split into Savings, Investments, and Checking.
      </p>
    </header>

    <div class="card">
      <div class="card-head">
        <h5>Your Income</h5>
        <p class="muted">
          Add each source of monthly income. We'll total it for you automatically.
        </p>

        <!-- inputs in a small grid for alignment -->
      </div>
      <!-- InputText & InputNumber; add your v-models -->
      <div class="grid">
        <InputText v-model="newIncome.source" placeholder="Income Source" />
        <InputNumber
          v-model="newIncome.amount"
          placeholder="Amount"
          mode="currency"
          currency="USD"
          locale="en-US"
        />
        <Button label="Add Income" @click="addIncome" />
      </div>
      <!-- DataTable with empty & totals -->

      <DataTable :value="incomes" responsiveLayout="scroll">
        <Column field="source" header="Source"></Column>
        <Column field="amount" header="Amount ($)"></Column>
      </DataTable>
    </div>

    <div class="card">
      <div class="card-head">
        <h5>Choose your Allocation</h5>
        <p class="muted">
          Pick what % goes to Savings & Investments. The rest will land in Checking.
        </p>
      </div>

      <div class="grid grid-thirds">
        <!-- Savings %, Investments, %, Checking % (read-only) -->

        <div>
          <InputNumber
            v-model="savingAllocation"
            suffix="%"
            :min="0"
            :max="100"
            :use-grouping="false"
            showButtons
          />
          <label for="savingAllocation"> to Savings</label>
        </div>

        <div>
          <InputNumber
            v-model="investmentAllocation"
            suffix="%"
            :min="0"
            :max="100"
            :use-grouping="false"
            showButtons
          />
          <label for="investmentAllocation"> to Investments</label>
        </div>
      </div>

      <div class="pill-row">
        <!-- Optional read-only $ amounts displayed in "pills" -->
        <Chart
          class="chart"
          type="pie"
          :data="{
            datasets: [
              {
                data: [allocation.checking, allocation.savings, allocation.investments],
              },
            ],
            labels: ['Checking', 'Savings', 'Investments'],
          }"
          :options="{
            plugins: {
              tooltip: {
                callbacks: {
                  label: function (context: any) {
                    return ` ${context.parsed}%`
                  },
                },
              },
            },
          }"
        />
      </div>
    </div>

    <div class="card">
      <div class="card-head">
        <h5>Your Expenses</h5>
        <p class="muted">Add recurring bills & choose which account pays each one.</p>
      </div>

      <div class="grid">
        <!-- Expense Name, amount, account dropdown, Add Button -->
        <InputText v-model="newExpense.name" placeholder="Expense Name" />
        <InputNumber
          v-model="newExpense.amount"
          placeholder="Amount"
          mode="currency"
          currency="USD"
          locale="en-US"
        />
        <Dropdown
          v-model="newExpense.from"
          :options="accountOptions.map((account) => account.label)"
          placeholder="From"
        />
        <Button label="Add Expense" @click="addExpense" />
      </div>

      <!-- Expenses DataTable -->
      <DataTable :value="expenses" responsiveLayout="scroll">
        <Column field="name" header="Expense"></Column>
        <Column field="amount" header="Amount ($)"></Column>
        <Column field="from" header="From (Account)"></Column>
      </DataTable>
    </div>
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
