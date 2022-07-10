import axios from 'axios'

import {
  queryStringify
} from '@/libs/utils'
class Http {
  constructor() {
    this.baseUrl = 'http://localhost:8087/pofa'
  }

  request(options) {
    const instance = axios.create()
    instance.defaults.withCredentials = true
    instance.defaults.baseURL = this.baseUrl
    if (options.json === true) {
      instance.defaults.headers.post['Content-Type'] = 'application/json'
      instance.defaults.headers.put['Content-Type'] = 'application/json'
    } else {
      instance.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;'
    }
    if (options.token) {
      instance.defaults.headers.token = options.token
    }
    instance.defaults.transformRequest = [data => {
      if (options.headers && options.headers['Content-Type']) {
        return data
      }
      if (options.json === true && typeof data !== 'string') {
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
        this._errorHandle(response.data, response.status)
      } else {
        this._errorHandle('服务器无响应', 500)
      }
      return Promise.reject(error)
    })
    return instance(options)
  }

  _errorHandle(res, status = 500) {
    let msg = res && res.msg
    if (res.msg === 'success') return
    if (status === 401 && msg) msg = '参数验证出错,传入的参数不符合API的要求'
    if (status === 404 && msg) msg = '您访问的资源未找到'
    
    //调用vuetify的错误消息弹框
    //Message.error(msg || '服务器无响应')
  }
}

export default new Http()
