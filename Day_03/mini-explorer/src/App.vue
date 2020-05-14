<template>
  <div id="app">
    <form @submit.prevent>
      <input type="text" v-model="blockId">
      <button @click="getBlock(blockId)">Search block</button>
    </form>
    <BlockDetails v-if="!loading" v-bind:block="block.result" />
  </div>
</template>

<script>
import BlockDetails from './components/BlockDetails.vue'

export default {
  name: 'app',
  components: {
    BlockDetails
  },
  data: function() {
    return {
      block: Object,
      loading: true,
      blockId: 0
    }
  },
  methods: {
    getBlock: async function(blockNumber) {
      this.loading = true;
      if (blockNumber != 'latest') {
        blockNumber = '0x' + parseInt(blockNumber).toString(16)
      }
      const request = JSON.stringify({"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":[blockNumber, true],"id":67});
      const rawResponse = await fetch('https://mainnet.infura.io/v3/1926810c66a24059b78116a14c3d3c54', {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: request
      });
      this.block = await rawResponse.json();
      this.loading = false;
    }
  },
  created(){
    this.getBlock('latest');
  }
}
</script>

<style>
input {
  padding: 10px;
  width: 25%;
  border-radius: 5px;
}
button {
  padding: 10px;
  border-radius: 5px;
  background-color: #aaa;
  width: 25%;
}
</style>
