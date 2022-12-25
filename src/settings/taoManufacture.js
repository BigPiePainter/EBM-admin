import http from '@/libs/http'

export const getProduct = data => {
    const args = {
        url: '/globalSocket/setAnnouncement',
        method: 'POST',
        data
    }
    return http.request(args)
}