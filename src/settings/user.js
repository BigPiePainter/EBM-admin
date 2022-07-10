import http from '@/libs/http'

export const userLogin = data => {
    const args = {
        url: '/user/login',
        method: 'POST',
        data
    }
    return http.request(args)
}
