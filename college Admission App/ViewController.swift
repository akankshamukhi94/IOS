//
//  ViewController.swift
//  AkankshaAssignment1
//
//  Created by Akanksha Mukhi on 2025-01-30.
//
import UIKit

enum AppTheme {
    case dark
    case light
    
    var backgroundColor: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .dark: return .white
        case .light: return .black
        }
    }
    
    
}

class WelcomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!  
    
    private var currentTheme: AppTheme = .dark {
        didSet {
            updateUIForTheme()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIForTheme()
    }
    
    @IBAction func themeToggle(_ sender: UISegmentedControl) {
        currentTheme = (sender.selectedSegmentIndex == 0) ? .dark : .light
    }
    
    private func updateUIForTheme() {
        UIView.animate(withDuration: 0.3) {
            
            self.view.backgroundColor = self.currentTheme.backgroundColor
            
            
            self.titleLabel.textColor = self.currentTheme.textColor
            self.label.textColor = self.currentTheme.textColor
            
            
        }
    }
}

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Table: UITableView!
    @IBOutlet weak var tuitionLabel: UILabel!
    
    let departments = ["Computer Science", "Arts", "Engineering", "Business", "Law", "Medicine", "Psychology", "Mathematics", "Biology", "Physics"]
    
    let tuitionFees: [String: Double] = [
        "Computer Science": 5000,
        "Arts": 3000,
        "Engineering": 7000,
        "Business": 6000,
        "Law": 10000,
        "Medicine": 15000,
        "Psychology": 4500,
        "Mathematics": 5500,
        "Biology": 6200,
        "Physics": 5800
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Table.dataSource = self
        Table.delegate = self

        
        Table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        print("ExploreViewController Loaded")
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = departments[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDepartment = departments[indexPath.row]
        if let tuition = tuitionFees[selectedDepartment] {
            tuitionLabel.text = "Fees for \(selectedDepartment): $\(tuition)"
        } else {
            tuitionLabel.text = "Tuition info not available"
        }
    }
}


class NameEntryViewController: UIViewController {

    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var agestepper: UIStepper!
    @IBOutlet weak var agelabel: UILabel!
    @IBOutlet weak var addrs: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var age: Int = 18 {
        didSet {
            agelabel.text = "\(age)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }

    private func setupUI() {
        errorLabel.isHidden = true
        agestepper.minimumValue = 13
        agestepper.maximumValue = 100
        agestepper.value = Double(age)
        agelabel.text = "\(age)"
        
        [FirstName, LastName, addrs, Phone, Email].forEach {
            $0?.delegate = self
        }
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func Stepped(_ sender: UIStepper) {
        age = Int(sender.value)
    }

    @IBAction func NextButton(_ sender: Any) {
        guard validateFields() else { return }
        performSegue(withIdentifier: "nextStep", sender: self)
    }

    @objc func handleTapGesture() {
        view.endEditing(true)
    }

    private func validateFields() -> Bool {
        guard let firstName = FirstName.text, !firstName.isEmpty,
              let lastName = LastName.text, !lastName.isEmpty,
              let address = addrs.text, !address.isEmpty,
              let phone = Phone.text, !phone.isEmpty else {
            errorLabel.text = "Please fill all required fields"
            errorLabel.isHidden = false
            return false
        }
        
        guard phone.count >= 10 else {
            errorLabel.text = "Phone number must be at least 10 digits"
            errorLabel.isHidden = false
            return false
        }
        
        errorLabel.isHidden = true
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextStep",
           let destinationVC = segue.destination as? AcademicViewController {
            destinationVC.firstName = FirstName.text ?? ""
            destinationVC.lastName = LastName.text ?? ""
            destinationVC.age = age
            destinationVC.address = addrs.text ?? ""
            destinationVC.phone = Phone.text ?? ""
            destinationVC.email = Email.text ?? ""
        }
    }
}

extension NameEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case FirstName: LastName.becomeFirstResponder()
        case LastName: addrs.becomeFirstResponder()
        case addrs: Phone.becomeFirstResponder()
        case Phone: Email.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

class AcademicViewController: UIViewController {
    
    var age: Int?
    var address: String?
    var phone: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    
    
    @IBOutlet weak var prevschool: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var courseOfStudy: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        setupGestures()

    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture() {
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toSummary" {
            return validateAcademicFields()
        }
        return true
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toSummary", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSummary",
           let destinationVC = segue.destination as? SubmissionViewController {
            
            destinationVC.firstName = firstName
            destinationVC.lastName = lastName
            destinationVC.age = age
            destinationVC.address = address
            destinationVC.phone = phone
            destinationVC.email = email
            
            
            destinationVC.prevschool = prevschool.text
            destinationVC.grade = grade.text
            destinationVC.courseOfStudy = courseOfStudy.text
        }
    }
    
    private func validateAcademicFields() -> Bool {
        guard let prevschool = prevschool.text, !prevschool.isEmpty,
              let grade = grade.text, !grade.isEmpty,
              let courseOfStudy = courseOfStudy.text, !courseOfStudy.isEmpty else {
            
            showError("Please fill all academic fields")
            return false
        }
        
        return true
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}


class SubmissionViewController: UIViewController {
    
    var firstName: String?
    var lastName: String?
    var age: Int?
    var address: String?
    var phone: String?
    
    
    var prevschool: String?
    var grade: String?
    var courseOfStudy: String?
    
    
    var email: String?
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayRegistrationDetails()
    }
    
    private func setupUI() {
        finishButton.layer.cornerRadius = 8
        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .left
    }
    
    private func displayRegistrationDetails() {
        let displayText = """
        ✅ Registration Complete!
        
        Personal Information:
        ---------------------
        Name: \(firstName ?? "N/A") \(lastName ?? "")
        Age: \(age != nil ? "\(age!)" : "N/A")
        Address: \(address ?? "N/A")
        Phone: \(phone ?? "N/A")
        
        Academic Information:
        ---------------------
        Previous School: \(prevschool ?? "N/A")
        Grade Level: \(grade ?? "N/A")
        courseOfStudy of Study: \(courseOfStudy  ?? "N/A")
        
        Account Information:
        --------------------
        Email: \(email ?? "N/A")
        """
        
        detailsLabel.text = displayText
    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Registration Complete",
            message: "Thank you for registering!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        
        present(alert, animated: true)
    }
}
class FeedbackViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var feedbackTextView: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true 
        progressView.progress = 0 
        setupTextView()
        setupTapGesture()
    }
    
    private func setupTextView() {
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.layer.cornerRadius = 8
        feedbackTextView.delegate = self 
    }
    
    private func setupTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        view.endEditing(true) 
        
        guard let feedback = feedbackTextView.text, !feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Feedback cannot be empty!")
            return
        }
        
        errorLabel.isHidden = true
        submitFeedback()
    }
    
    private func submitFeedback() {
        progressView.progress = 0
        submitButton.isEnabled = false
        
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.progressView.progress += 0.1
            if self.progressView.progress >= 1.0 {
                timer.invalidate()
                self.showSuccessMessage()
            }
        }
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            
            if let navigationController = self?.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                
                self?.dismiss(animated: true)
            }
        })
        present(alert, animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}






