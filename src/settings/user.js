import http from '@/libs/http'

export const userLogin = data => {
    const args = {
        url: '/user/login',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const isLogin = data => {
    const args = {
        url: '/user/isLogin',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getSubUsers = data => {
    const args = {
        url: '/user/getSubUsers',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const registUser = data => {
    const args = {
        url: '/user/regist',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getAllUsers = data => {
    const args = {
        url: '/user/getAllUsers',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const modifyUser = data => {
    const args = {
        url: '/user/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}