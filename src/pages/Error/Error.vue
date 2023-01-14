<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="诶呀！">
    </PageHeader>
    <div class="ma-6">
      <span>404了！这是什么页面啊？</span>
    </div>
    
  </div>
</template>

<script>
import config from "@/config";
import PageHeader from "@/components/PageHeader";
export default {
  name: "Error",
  components: {
    PageHeader,
  },
  data() {
    return {
      config,
    };
  },
};
</script>

<style src="./Error.scss" lang="scss"></style>
