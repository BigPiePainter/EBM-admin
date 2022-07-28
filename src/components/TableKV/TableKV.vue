<template>
  <v-data-table
    :headers="[
      { align: 'start', value: 'key' },
      { align: 'start', value: 'value' },
    ]"
    :items="items"
    hide-default-footer
    hide-default-header
    disable-sort
  >
    <template v-slot:[`item.key`]="{ item }">
      <div class="ml-3">
        {{ item.key }}
      </div>
    </template>
  </v-data-table>
</template>

<script>
export default {
  props: {
    items: Array,
  },

  data() {
    return {};
  },
};
</script>

<style scoped>
</style>