import Vue from "vue";

import Router from "vue-router";

import Layout from "@/components/Layout/Layout";

// Pages
import MainPage from "@/pages/MainPage/MainPage";
import Dashboard from "@/pages/Dashboard/Dashboard";
import ProfitChart from "@/pages/Dashboard/ProfitChart";
import ProfitTable from "@/pages/Dashboard/ProfitTable";
import PartnerGet from "@/pages/PartnerGet/PartnerGet";
import MismatchProducts from "@/pages/MismatchProducts/MismatchProducts";
import DeletedProducts from "@/pages/DeletedProducts/DeletedProducts";

import Category from "@/pages/Category/Category";
import ProductsGet from "@/pages/ProductsGet/ProductsGet";
import ProductsPut from "@/pages/ProductsPut/ProductsPut";

import Error from "@/pages/Error/Error";

import Login from "@/pages/Login/Login";

import Order from "@/pages/Order/Order";
import Brush from "@/pages/Order/Brush";
import IndividualBrush from "@/pages/Order/IndividualBrush";
import Input from "@/pages/Order/Input";
import Return from "@/pages/Order/Return";
import Department from "@/pages/Department/Department";
import Team from "@/pages/Team/Team";
import AllEmployees from "@/pages/AllEmployees/AllEmployees";
import Employee from "@/pages/Employee/Employee";

import SkuHaker from "@/pages/Tools/SkuHaker";
import ProductCopy from "@/pages/Tools/ProductCopy";
import EconomyAllProduct from "@/pages/Economy/EconomyAllProduct";

import MyRequirements from "@/pages/Middleground/MyRequirements";
import ProductsDB from "@/pages/Middleground/ProductsDB";
import RequirementsGround from "@/pages/Middleground/RequirementsGround";

import { isLogin } from "@/settings/user";

Vue.use(Router);

var routerConfig = {
  routes: [
    {
      path: "/login",
      name: "Login",
      component: Login,
    },
    {
      path: "/",
      redirect: "login",
      name: "Layout",
      component: Layout,
      children: [
        {
          path: "productcopy",
          name: "ProductCopy",
          component: ProductCopy,
        },
        {
          path: "skuhaker",
          name: "SkuHaker",
          component: SkuHaker,
        },
        {
          path: "mainpage",
          name: "MainPage",
          component: MainPage,
        },
        {
          path: "dashboard",
          name: "Dashboard",
          component: Dashboard,
        },
        {
          path: "profitChart",
          name: "ProfitChart",
          component: ProfitChart,
        },
        {
          path: "profitTable",
          name: "ProfitTable",
          component: ProfitTable,
        },
        {
          path: "partnerget",
          name: "PartnerGet",
          component: PartnerGet,
        },
        {
          path: "mismatchProducts",
          name: "MismatchProducts",
          component: MismatchProducts,
        },
        {
          path: "deletedProducts",
          name: "DeletedProducts",
          component: DeletedProducts,
        },
        {
          path: "category",
          name: "Category",
          component: Category,
        },
        {
          path: "economyAllProduct",
          name: "EconomyAllProduct",
          component: EconomyAllProduct,
        },
        {
          path: "order",
          name: "Order",
          component: Order,
        },
        {
          path: "return",
          name: "Return",
          component: Return,
        },
        {
          path: "input",
          name: "Input",
          component: Input,
        },
        {
          path: "brush",
          name: "Brush",
          component: Brush,
        },
        {
          path: "individualbrush",
          name: "IndividualBrush",
          component: IndividualBrush,
        },
        {
          path: "all_employees",
          name: "AllEmployees",
          component: AllEmployees,
        },
        {
          path: "employee",
          name: "Employee",
          component: Employee,
        },
        {
          path: "department",
          name: "Department",
          component: Department,
        },
        {
          path: "team",
          name: "Team",
          component: Team,
        },
        {
          path: "productsget",
          name: "ProductsGet",
          component: ProductsGet,
        },
        {
          path: "productsput",
          name: "ProductsPut",
          component: ProductsPut,
        },
        {
          path: "myrequirements",
          name: "MyRequirements",
          component: MyRequirements,
        },
        {
          path: "productsdb",
          name: "ProductsDB",
          component: ProductsDB,
        },
        {
          path: "requirementsground",
          name: "RequirementsGround",
          component: RequirementsGround,
        },
        {
          path: "*",
          name: "Error",
          component: Error,
        },
      ],
    },
  ],
};

var router = new Router(routerConfig);

router.beforeEach((to, from, next) => {
  console.log("路由行为");
  console.log("to", to);
  console.log("from", from);

  if (to.name == "Login") return void next();

  console.log("检测登陆状态");
  isLogin({})
    .then((res) => {
      console.log("登陆状态", res);
      if (res.data.isLogin) {
        if (!Vue.prototype.store.state.user.uid) {
          router.push("/login");
          return;
        }
        next();
      } else {
        Vue.prototype.global.errorAlert("泼发EBC：请先登录");
        router.push("/login");
      }
    })
    .catch((err) => {
      console.log(err);
      router.push("/login");
      Vue.prototype.global.infoAlert("泼发EBC：服务器未连接");
    });
});

console.log(router);

export default router;
