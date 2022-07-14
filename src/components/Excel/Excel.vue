<template>
  <div id="x-spreadsheet"></div>
</template>

<script>
import Spreadsheet from "x-data-spreadsheet";
import zhCN from "x-data-spreadsheet/src/locale/zh-cn";

export default {
  name: "Excel",
  props: {
    data: Array,
  },
  data() {
    return {};
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
      console.log("init");

      const rows10 = { len: 100000 };
      for (let i = 0; i < 100000; i += 1) {
        rows10[i] = {
          cells: {
            0: { text: "A-" + i },
            1: { text: "B-" + i },
            2: { text: "C-" + i },
            3: { text: "D-" + i },
            4: { text: "E-" + i },
            5: { text: "F-" + i },
          },
        };
      }

      const rows = {
        len: 1000,
        1: {
          cells: {
            0: { text: "testingtesttestetst" },
            2: { text: "testing" },
          },
        },
        2: {
          cells: {
            0: { text: "render", style: 0 },
            1: { text: "Hello" },
            2: { text: "haha" },
          },
        },
        8: {
          cells: {
            8: { text: "border test", style: 0 },
          },
        },
      };
      /*
      this.data = [
        {
          //freeze: "B3",
          styles: [
            {
              bgcolor: "#f4f5f8",
              textwrap: true,
              color: "#900b09",
              border: {
                top: ["thin", "#0366d6"],
                bottom: ["thin", "#0366d6"],
                right: ["thin", "#0366d6"],
                left: ["thin", "#0366d6"],
              },
            },
          ],
          cols: {
            len: 5,
            2: { width: 200 },
          },
          rows,
        },
        { name: "sheet-test", rows: rows10 },
        { name: "sheet-test", rows: rows10 },
      ];
      */

      var data2 = [
        {
          name: "测试",
          //freeze: "B3",
          styles: [
            {
              bgcolor: "#f4f5f8",
              textwrap: true,
              color: "#900b09",
              border: {
                top: ["thin", "#0366d6"],
                bottom: ["thin", "#0366d6"],
                right: ["thin", "#0366d6"],
                left: ["thin", "#0366d6"],
              },
            },
          ],
          cols: {
            len: 5,
            2: { width: 200 },
          },
          rows,
        },
        //{ name: "sheet-test", rows: rows10 },
      ];
      data2.a = [];

      Spreadsheet.locale("zh-cn", zhCN);
      console.log(this.data);

      var xs = new Spreadsheet("#x-spreadsheet", {
        showToolbar: true,
        showGrid: true,
        view: {
          height: () => document.documentElement.clientHeight - 48,
          width: () => document.documentElement.clientWidth,
        },
      })
        .loadData(this.data)
        .change((cdata) => {
          console.log(cdata);
          console.log(">>>", xs.getData());
        });

      xs
        .on("cell-selected", (cell, ri, ci) => {
          console.log("cell:", cell, ", ri:", ri, ", ci:", ci);
        })
        .on("cell-edited", (text, ri, ci) => {
          console.log("text:", text, ", ri: ", ri, ", ci:", ci);
        });

      /*
      setTimeout(() => {
        // xs.loadData([{ rows }]);
        xs.cellText(14, 3, "cell-text").reRender();
        console.log("cell(8, 8):", xs.cell(8, 8));
        console.log("cellStyle(8, 8):", xs.cellStyle(8, 8));
      }, 5000);
      */
    },
  },
};
</script>

<style scoped>
</style>