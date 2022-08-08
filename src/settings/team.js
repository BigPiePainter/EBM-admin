import http from '@/libs/http'

export const getTeam = data => {
    const args = {
        url: '/team/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addTeam = data => {
    const args = {
        url: '/team/add',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const modifyTeam = data => {
    const args = {
        url: '/team/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}