import http from '@/libs/http'

export const loadAscriptions = data => {
    const args = {
        url: '/ascription/get',
        method: 'POST',
        data
    }
    return http.request(args)
}
