<template>
    <div>
        <v-data-table :headers="headers" :items="memberItems">

        </v-data-table>
    </div>
</template>

<script>
export default {
    comments: {},

    props: {
        allUsers: Array,
        allGroups: Array,
        groupInfo: Object,
    },

    created() {
        this.init();
        // console.log(this.allUsers);
        // console.log(this.groupInfo);
    },

    data() {
        return {
            headers: [
                { text: "组员姓名", value: "nick" },
                { text: "账号", value: "username" },
                { text: "所属小组", value: "calculatedPermission" },
                { text: "联系方式", value: "contact" },
                { text: "备注", value: "note" }
            ],

            memberItems: [],

        }
    },
    //测试git
    methods: {
        init() {
            console.log(this.allGroups)

            this.memberItems = this.allUsers.filter(i => JSON.parse(i.permission).a && JSON.parse(i.permission).a.g.find(p => p == this.groupInfo.uid));
            this.memberItems.forEach(i => {
                var permission = JSON.parse(i.permission)
                if (permission.a) {
                    i.calculatedPermission = permission.a.g.map(id => this.allGroups.find(g => g.uid == id).name)
                }
            })
        },

    },
}
</script>