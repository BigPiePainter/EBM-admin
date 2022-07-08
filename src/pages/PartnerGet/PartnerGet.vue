<template>
  <v-container fluid>
    <div class="tables-basic">
      <v-row>
        <v-col cols="12">
          <v-card class="employee-list mb-1">
            <v-card-title class="pa-6 pb-3">
              <p>产品信息</p>
              <v-spacer></v-spacer>
              <v-text-field
                v-model="mock.employeeTable.search"
                append-icon="mdi-magnify"
                label="Search"
                clearable
                single-line
                hide-details
              ></v-text-field>
            </v-card-title>
            <v-data-table
              v-model="mock.employeeTable.selected"
              :headers="mock.employeeTable.headers"
              :items="mock.employeeTable.employee"
              :search="mock.employeeTable.search"
              item-key="name"
              show-select>
            </v-data-table>
          </v-card>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
import mock from './mock'

export default {
  name: 'Tables',
  data() {
    return {
      mock
    }
  }
}

</script>

<style src="./PartnerGet.scss" lang="scss">
</style>