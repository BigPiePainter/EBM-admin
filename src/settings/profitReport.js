import http from '@/libs/http'

export const getProfitReport = data => {
    const args = {
        url: '/profitReport/getProfitReport',
        method: 'POST',
        data,
    }
    return http.request(args)
}

export const getMismatchedSkus = data => {
    const args = {
        url: '/profitReport/getMismatchedSkus',
        method: 'POST',
        data,
    }
    return http.request(args)
}





