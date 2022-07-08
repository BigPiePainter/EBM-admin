<template>
  <div class="dropbox">
    <h2 class="text-center">把要上传的文件拖动到这里</h2>
  </div>
</template>
<script>
export default {
  name: "DropFile",
  data() {
    return {
      dropActive: false,
    };
  },
  methods: {
    dropEvent(e) {
      this.dropActive = false;
      e.stopPropagation();
      e.preventDefault();
      this.uploadFile(e.dataTransfer.files);
    },
    uploadFile(file) {
      // 渲染上传文件
      console.log(file[0], "file");
      if (file && file.length) {
        //自行发挥，存本地或上传服务器
      }
    },
  },
  mounted() {
    let dropArea = document.getElementById("drop-area");
    dropArea.addEventListener("drop", this.dropEvent, false);
    dropArea.addEventListener("dragleave", (e) => {
      e.stopPropagation();
      e.preventDefault();
      this.dropActive = false;
    });
    dropArea.addEventListener("dragenter", (e) => {
      e.stopPropagation();
      e.preventDefault();
      this.dropActive = true;
    });
    dropArea.addEventListener("dragover", (e) => {
      e.stopPropagation();
      e.preventDefault();
      this.dropActive = true;
    });
  },
};
</script>
<style scoped lang="scss">
@import "../../styles/app";
.dropbox {
   border: .23rem dashed #aaa;
   min-height: 5rem;
   margin: 30px;
   text-align: center;

  }
</style>