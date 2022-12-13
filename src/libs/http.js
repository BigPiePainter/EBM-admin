import axios from 'axios'
import Vue from 'vue'
import {
  queryStringify
} from '@/libs/utils'
class Http {
  constructor() {
    console.log("后端网址", process.env.VUE_APP_API_URL)
    this.baseUrl = "http://" + process.env.VUE_APP_API_URL
  }

  request(options) {
    const instance = axios.create()
    instance.defaults.withCredentials = true
    instance.defaults.baseURL = this.baseUrl
    if (options.json === true) {
      instance.defaults.headers.post['Content-Type'] = 'application/json'
      instance.defaults.headers.put['Content-Type'] = 'application/json'
    } else if (options.file === true) {
      console.log("formdata")
      instance.defaults.headers.post['Content-Type'] = 'multipart/form-data'
    } else {
      instance.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded'
    }



    if (localStorage.token) {
      instance.defaults.headers.pofatoken = localStorage.token
    }
    if (options.token) {
      instance.defaults.headers.pofatoken = options.token
    }
    if (options.onUploadProgress) {
      instance.defaults.onUploadProgress = options.onUploadProgress
    }

    instance.defaults.transformRequest = [data => {
      if (options.file) return data

      if (options.headers && options.headers['Content-Type']) {
        console.log("预处理1")
        return data
      }
      if (options.json === true && typeof data !== 'string') {
        console.log("预处理2")
        return JSON.stringify(data)
      }
      return queryStringify(data)
    }]

    instance.interceptors.request.use(config => {
      return config
    }, error => {
      return Promise.reject(error)
    })
    instance.interceptors.response.use(res => {
      const { data, status } = res
      if (!data || data.msg !== 'success') {
        this._errorHandle(data, data.code)
        return Promise.reject(res)
      }
      this._errorHandle(data, status)

      return data
    }, (error) => {
      const response = error.response
      if (response) {
        this._errorHandle(error, response.status)
      } else {
        this._errorHandle('服务器无响应', 500)
      }

      return Promise.reject(error)
    })

    console.log(options)
    return instance(options)
  }

  _errorHandle(data) {
    if (data.constructor.name == "AxiosError") {
      Vue.prototype.global.errorAlert(data.code.toString())
    }
  }
}

export default new Http()
