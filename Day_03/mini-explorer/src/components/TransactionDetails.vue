<template>
  <div>
    <h1>Transaction: {{transaction.transactionIndex | toDecimal}}</h1>
    <p>From: {{transaction.from}}</p>
    <p>To: {{transaction.to}}</p>
    <p>Hash: {{transaction.hash}}</p>
    <p>Gas: {{transaction.gas | toDecimal}}</p>
    <p>Gas price: {{transaction.gasPrice | toDecimal}} wei</p>
    <p>Value: {{transaction.value | toDecimal}} wei</p>
  </div>
</template>

<script>
export default {
  props: ['transaction']
}
</script>

<style scoped>
  div {
    padding: 10px;
    margin: 10px 20px;
    border-radius: 5px;
    background-color: #aaa;
  }
</style>