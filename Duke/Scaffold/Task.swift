//
//  Task.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/23/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import Resolver
import Disk
//https://peterfriese.dev/posts/xcode-shortcuts/
/*
enum TaskPriority: Int, Codable {
  case high
  case medium
  case low
}
*/
struct UserTask: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var priority: TaskPriority
  var completed: Bool
  @ServerTimestamp var createdTime: Timestamp? ///Using a server-side timestamp is important when working with data that originates from multiple clients, as the clocks on the clients are most likely not in sync with each other.
  var userId: String?
}
/*
struct TaskListView: View {
  @ObservedObject var taskListVM = TaskListViewModel()
  @State var presentAddNewItem = false
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          ForEach (taskListVM.taskCellViewModels) { taskCellVM in
            TaskCell(taskCellVM: taskCellVM)
          }
          .onDelete { indexSet in
            self.taskListVM.removeTasks(atOffsets: indexSet)
          }
          if presentAddNewItem {
            TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in
              if case .success(let task) = result {
                self.taskListVM.addTask(task: task)
                  self.presentAddNewItem = false
              }
//              self.presentAddNewItem.toggle()
            }
          }
        }
        Button(action: {
            self.presentAddNewItem.toggle()
        }) {
          HStack {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 20, height: 20)
            Text("New Task")
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .navigationBarTitle("Tasks")
    }
  }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
 */

enum InputError: Error {
  case empty
}

/*
struct TaskCell: View {
  @ObservedObject var taskCellVM: TaskCellViewModel
  var onCommit: (Result<UserTask, InputError>) -> Void = { _ in }
  
  var body: some View {
    HStack {
      Image(systemName: taskCellVM.completionStateIconName)
        .resizable()
        .frame(width: 20, height: 20)
        .onTapGesture {
          self.taskCellVM.task.completed.toggle()
        }
        
        TextField("Enter task title", text: $taskCellVM.task.title,
                  onCommit: {
            if !self.taskCellVM.task.title.isEmpty {
                self.onCommit(.success(self.taskCellVM.task))
            }
            else {
                self.onCommit(.failure(.empty))
            }
        }).id(taskCellVM.id)
    }
  }
}

class TaskListViewModel: ObservableObject {
  @Published var taskRepository: TaskRepository = Resolver.resolve()
  @Published var taskCellViewModels = [TaskCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    taskRepository.$tasks.map { tasks in
      tasks.map { task in
        TaskCellViewModel(task: task)
      }
    }
    .assign(to: \.taskCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeTasks(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.taskCellViewModels[$0] }
    viewModels.forEach { taskCellViewModel in
      taskRepository.removeTask(taskCellViewModel.task)
    }
  }
  
  func addTask(task: UserTask) {
    taskRepository.addTask(task)
  }
}

class TaskCellViewModel: ObservableObject, Identifiable  {
  @Injected var taskRepository: TaskRepository
  
  @Published var task: UserTask
  
  var id: String = ""
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  static func newTask() -> TaskCellViewModel {
    TaskCellViewModel(task: UserTask(title: "", priority: TaskPriority.medium, completed: false))
  }
  
  init(task: UserTask) {
    self.task = task
    
    $task
      .map { $0.completed ? "checkmark.circle.fill" : "circle" }
      .assign(to: \.completionStateIconName, on: self)
      .store(in: &cancellables)

    $task
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
    
    $task
      .dropFirst()
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .sink { task in
        self.taskRepository.updateTask(task)
      }
      .store(in: &cancellables)
  }
  
}
 */

class BaseTaskRepository {
  @Published var tasks = [UserTask]()
}

protocol TaskRepository where Self: BaseTaskRepository {
  func addTask(_ task: UserTask)
  func removeTask(_ task: UserTask)
  func updateTask(_ task: UserTask)
}

#warning("should look into deleting this or using this to cache our data on disk")
class LocalTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
  override init() {
    super.init()
    loadData()
  }
  
  func addTask(_ task: UserTask) {
    self.tasks.append(task)
    saveData()
  }
  
  func removeTask(_ task: UserTask) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks.remove(at: index)
      saveData()
    }
  }
  
  func updateTask(_ task: UserTask) {
    if let index = self.tasks.firstIndex(where: { $0.id == task.id } ) {
      self.tasks[index] = task
      saveData()
    }
  }
  
  private func loadData() {
    if let retrievedTasks = try? Disk.retrieve("tasks.json", from: .documents, as: [UserTask].self) {
      self.tasks = retrievedTasks
    }
  }
  
  private func saveData() {
    do {
      try Disk.save(self.tasks, to: .documents, as: "tasks.json")
    }
    catch let error as NSError {
        showErrorAlertView(error.localizedDescription, error.localizedFailureReason! + error.localizedRecoverySuggestion!, handler: {}, failureHandler: {})
      fatalError("""
        Domain: \(error.domain)
        Code: \(error.code)
        Description: \(error.localizedDescription)
        Failure Reason: \(error.localizedFailureReason ?? "")
        Suggestions: \(error.localizedRecoverySuggestion ?? "")
        """)
    }
  }
}

class FirestoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    ///https://peterfriese.dev/posts/replicating-reminder-swiftui-firebase-part3/
    ///https://www.swiftanytime.com/blog/contextmenu-in-swiftui
    #warning("Configure Sign In With Apple after enrolling in Apple Dev program again")
    var db = Firestore.firestore()
    
    @Injected var authenticationService: AuthenticationService
    var tasksPath: String = "tasks"
    var userId: String = "unknown"
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { user in
                self.loadData()
            })
            .store(in: &cancellables)
    }
    
    private func loadData() {
        db.collection(tasksPath)
            .whereField("userId", isEqualTo: self.userId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document -> UserTask? in
                        try? document.data(as: UserTask.self)
                    }
                }
            }
    }
    
    func addTask(_ task: UserTask) {
        do {
            var userTask = task
            userTask.userId = self.userId
            let _ = try db.collection(tasksPath).addDocument(from: userTask)
        }
        catch {
            fatalError("Unable to encode task: \(error.localizedDescription).")
        }
    }
    
    func removeTask(_ task: UserTask) {
        if let taskID = task.id {
            db.collection(tasksPath).document(taskID).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateTask(_ task: UserTask) {
        if let taskID = task.id {
            do {
                try db.collection(tasksPath).document(taskID).setData(from: task)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
    }
}


class AuthenticationService: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    
    func signIn() {
        registerStateListener()
        Auth.auth().signInAnonymously()
    }
    
    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user
            
            if let user = user {
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid).")
            }
            else {
                print("User signed out.")
            }
        }
    }
}

#warning("come back and flesh out this code for Apple Sign-In")
/*
enum SignInState: String {
  case signIn
  case link
  case reauth
}

class SignInWithAppleCoordinator: NSObject {
  @LazyInjected private var taskRepository: TaskRepository
  @LazyInjected private var authenticationService: AuthenticationService
  
  private weak var window: UIWindow!
  private var onSignedInHandler: ((User) -> Void)?

  private var currentNonce: String?
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  private func appleIDRequest(withState: SignInState) -> ASAuthorizationAppleIDRequest {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.state = withState.rawValue
    
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
    
    return request
  }

  func signIn(onSignedInHandler: @escaping (User) -> Void) {
    self.onSignedInHandler = onSignedInHandler
    
    let request = appleIDRequest(withState: .signIn)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  
  func link(onSignedInHandler: @escaping (User) -> Void) {
    self.onSignedInHandler = onSignedInHandler
    
    let request = appleIDRequest(withState: .link)
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

}

extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
        return
      }
      guard let stateRaw = appleIDCredential.state, let state = SignInState(rawValue: stateRaw) else {
        print("Invalid state: request must be started with one of the SignInStates")
        return
      }
      
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)

      switch state {
      case .signIn:
        Auth.auth().signIn(with: credential) { (result, error) in
          if let error = error {
            print("Error authenticating: \(error.localizedDescription)")
            return
          }
          if let user = result?.user {
            if let onSignedInHandler = self.onSignedInHandler {
              onSignedInHandler(user)
            }
          }
        }
      case .link:
        if let currentUser = Auth.auth().currentUser {
          currentUser.link(with: credential) { (result, error) in
            if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
              print("The user you're signing in with has already been linked, signing in to the new user and migrating the anonymous users [\(currentUser.uid)] tasks.")
              
              if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                print("Signing in using the updated credentials")
                Auth.auth().signIn(with: updatedCredential) { (result, error) in
                  if let user = result?.user {
                    // future feature: migrate the anonymous user's tasks to the permanent account
                    
                    self.doSignIn(appleIDCredential: appleIDCredential, user: user)
                  }
                }
              }
            }
            else if let error = error {
              print("Error trying to link user: \(error.localizedDescription)")
            }
            else {
              if let user = result?.user {
                self.doSignIn(appleIDCredential: appleIDCredential, user: user)
              }
            }
          }
        }
      case .reauth:
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
          if let error = error {
            print("Error authenticating: \(error.localizedDescription)")
            return
          }
          if let user = result?.user {
            self.doSignIn(appleIDCredential: appleIDCredential, user: user)
          }
        })
      }
    }
  }
  
  private func doSignIn(appleIDCredential: ASAuthorizationAppleIDCredential, user: User) {
    if let fullName = appleIDCredential.fullName {
      if let givenName = fullName.givenName, let familyName = fullName.familyName {
        let displayName = "\(givenName) \(familyName)"
        self.authenticationService.updateDisplayName(displayName: displayName) { result in
          switch result {
          case .success(let user):
            print("Succcessfully update the user's display name: \(String(describing: user.displayName))")
          case .failure(let error):
            print("Error when trying to update the display name: \(error.localizedDescription)")
          }
          self.callSignInHandler(user: user)
        }
      }
      else {
        self.callSignInHandler(user: user)
      }
    }
  }
  
  private func callSignInHandler(user: User) {
    if let onSignedInHandler = self.onSignedInHandler {
      onSignedInHandler(user)
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Sign in with Apple errored: \(error.localizedDescription)")
  }
  
}

extension SignInWithAppleCoordinator: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}
 */
