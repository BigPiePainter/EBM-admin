import http from '@/libs/http'

export const getCategory = data => {
    const args = {
        url: '/category/get',
        method: 'POST',
        data
    }
    return http.request(args)
}