import http from '@/libs/http'

export const getProfitReport = data => {
    const args = {
        url: '/profitReport/getProfitReport',
        method: 'POST',
        data,
    }
    return http.request(args)
}





