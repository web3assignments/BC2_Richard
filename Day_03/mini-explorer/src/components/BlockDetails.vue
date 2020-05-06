<template>
  <div>
    <h1>Block: {{block.number | toDecimal}}</h1>
    <p>Hash: {{block.hash}}</p>
    <p>Difficulty: {{block.difficulty | toDecimal}}</p>
    <p>Gas limit: {{block.gasLimit | toDecimal}}</p>
    <p>Gas used: {{block.gasUsed | toDecimal}}</p>
    <p>Difficulty: {{block.difficulty | toDecimal}}</p>
    <p>Miner: {{block.miner}}</p>
    <p>Size: {{block.size | toDecimal}} bytes</p>
    <p>Date: {{block.timestamp | toDecimal | toDate}}</p>
    <button @click="showTransactions = !showTransactions">Show {{block.transactions.length}} transactions</button>
    <div v-if="showTransactions">
      <transaction-details v-for="transaction in block.transactions" v-bind:key="transaction.transactionIndex" v-bind:transaction="transaction" />
    </div>
  </div>
</template>

<script>
import TransactionDetails from './TransactionDetails.vue'
export default {
  props: ['block'],
  data: function() {
    return {
      showTransactions: false
    }
  },
  components: {
    TransactionDetails
  }
}
</script>

<style scoped>
  button {
    width: 100%;
  }
</style>