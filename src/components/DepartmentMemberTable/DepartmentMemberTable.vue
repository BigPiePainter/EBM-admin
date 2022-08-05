<template>
    <div>
        <v-data-table
        :headers="headers"
        :items="memberItems">

        </v-data-table>
    </div>
</template>

<script>
import { getSubUsers } from "@/settings/user";
export default {
    comments: {},

    props: {},

    created() {
        this.init();
    },

    data() {
        return {
            headers: [
                {text:"部门员工姓名", value:"name"},
                {text:"账号", value:"account"},
                {text:"所属部门", value:"belong"},
                {text:"联系方式", value:"contact"},
                {text:"备注", value:"note"}
            ],

            memberItems: [],

            userInfos: [],

            idToNick: {},
        }
    },

    methods: {
        init() {
            this.loading = true;

            getSubUsers()
                .then((res) => {
                    this.loading = false;
                    this.userInfos = res.data.userInfos;
                    this.userAnalyze();

                })
                .catch(() => {
                    this.loading = false;
                });
        },

        userAnalyze() {
            this.userInfos.forEach((user) => {
                console.log(user);
                this.idToNick[user.uid] = user.nick;
                user.calculatedGender = "";
                if (null != user.gender) {
                    user.calculatedGender = user.gender == 1 ? "男" : "女";
                }
                user.calculatedPermission = JSON.parse(user.permission);
            });
            this.userInfos.forEach((user) => {
                console.log(user);
                if (user.uid == 1) return; //admin
                user.calculatedCreator = `${this.idToNick[user.creatorId]}`;
            });
        },
    },
}
</script>