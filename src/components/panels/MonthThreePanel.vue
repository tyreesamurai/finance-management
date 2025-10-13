<script setup lang="ts">
import TabPanel from "primevue/tabpanel";

defineProps<{
	accounts: {
		checkings: { label: string; amount: number };
		savings: { label: string; amount: number };
		brokerage: { label: string; amount: number };
		creditCard: { label: string; amount: number };
	};
}>();
</script>

<template>
  <TabPanel value="november">
    <h1>Month Three</h1>
    <h2>
      This month your checking account is going to go up
      {{ accounts.checkings.amount }} dollars
    </h2>
    <h2>
      This month your savings account is going to go up
      {{ accounts.savings.amount }} dollars
    </h2>
    <h2>
      This month your brokerage account is going to go up
      {{ accounts.brokerage.amount }} dollars
    </h2>
    <h1>Quick CI/CD Test</h1>
  </TabPanel>
</template>
