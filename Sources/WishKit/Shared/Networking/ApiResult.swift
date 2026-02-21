import Foundation

enum ApiResult<Success, Error> {

    case success(Success)

    case failure(Error)
}
