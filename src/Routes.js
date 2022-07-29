import Vue from 'vue';
import Router from 'vue-router';

import Layout from '@/components/Layout/Layout';

// Pages
import Dashboard from '@/pages/Dashboard/Dashboard';
import PartnerGet from '@/pages/PartnerGet/PartnerGet'
import ProductsGet from '@/pages/ProductsGet/ProductsGet'
import ProductsPut from '@/pages/ProductsPut/ProductsPut'
import Tables from '@/pages/Tables/Basic'
import Transport from '@/pages/Transport/Transport'
import Notifications from '@/pages/Notifications/Notifications'
import Icons from '@/pages/Icons/Icons'
import Charts from '@/pages/Charts/Charts'
import Maps from '@/pages/Maps/Google'
import Error from "@/pages/Error/Error";
import Login from "@/pages/Login/Login";

import Order from "@/pages/Order/Order";
import Brush from "@/pages/Order/Brush";
import Input from "@/pages/Order/Input";
import Return from "@/pages/Order/Return";
import Department from "@/pages/Department/Department";
import Group from "@/pages/Group/Group";
import AllEmployees from "@/pages/AllEmployees/AllEmployees";
import Employee from "@/pages/Employee/Employee";


import { isLogin } from "@/settings/user"

Vue.use(Router);


var routerConfig = {
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/',
      redirect: 'login',
      name: 'Layout',
      component: Layout,
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: Dashboard,
        },
        {
          path: 'partnerget',
          name: 'PartnerGet',
          component: PartnerGet,
        },
        {
          path: 'order',
          name: 'Order',
          component: Order,
        },
        {
          path: 'return',
          name: 'Return',
          component: Return,
        },
        {
          path: 'input',
          name: 'Input',
          component: Input,
        },
        {
          path: 'brush',
          name: 'Brush',
          component: Brush,
        },
        {
          path: 'all_employees',
          name: 'AllEmployees',
          component: AllEmployees,
        },
        {
          path: 'employee',
          name: 'Employee',
          component: Employee,
        },
        {
          path: 'department',
          name: 'Department',
          component: Department,
        },
        {
          path: 'group',
          name: 'Group',
          component: Group,
        },
        {
          path: 'productsget',
          name: 'ProductsGet',
          component: ProductsGet,
        },
        {
          path: 'productsput',
          name: 'ProductsPut',
          component: ProductsPut,
        },
        {
          path: 'tables',
          name: 'Tables',
          component: Tables
        },
        {
          path: 'notifications',
          name: 'Notifications',
          component: Notifications
        },
        {
          path: 'icons',
          name: 'Icons',
          component: Icons
        },
        {
          path: 'charts',
          name: 'Charts',
          component: Charts
        },
        {
          path: 'maps',
          name: 'Maps',
          component: Maps
        },
        {
          path: 'transport',
          name: 'Transport',
          component: Transport
        },
      ],
    },
    {
      path: '*',
      name: 'Error',
      component: Error,
    }
  ],
}

var router = new Router(routerConfig)

router.beforeEach((to, from, next) => {
  if (to.name == "Login") { next(); return; }


  isLogin({}).then((res) => {
    console.log(res)
    if (res.data.isLogin) {

      if (!Vue.prototype.global.user.uid) {
        router.push("/login");
        return
      }
      next();
    } else {
      Vue.prototype.global.errorAlert("泼发EBC：请先登录")
      router.push("/login");
    }
  })

  console.log(to)
  console.log(from)
  console.log("？？？？？？？？？")

});

console.log(router)


export default router;
