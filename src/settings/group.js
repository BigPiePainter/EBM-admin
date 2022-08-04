import http from '@/libs/http'

export const getGroup = data => {
    const args = {
        url: '/team/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addGroup = data => {
    const args = {
        url: '/team/add',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const modifyGroup = data => {
    const args = {
        url: '/team/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}