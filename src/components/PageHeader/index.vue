<template>
  <div>
    <div class="page-header d-flex align-center">
      <span class="px-6 page-header-title">{{ title }}</span>
      <slot />
    </div>
    <v-divider></v-divider>
  </div>
</template>

<script>
export default {
  props: {
    title: String,
  },

  data() {
    return {};
  },
};
</script>

<style lang="scss">
.page-header {
  .page-header-title {
    font-size: 1.15rem;
  }
}
</style>