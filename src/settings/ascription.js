import http from '@/libs/http'

export const loadAscriptions = data => {
    const args = {
        url: '/ascription/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteAscription = data => {
    const args = {
        url: '/ascription/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}