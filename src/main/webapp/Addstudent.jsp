<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Add Student</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <style>
        :root {
            --bs-body-bg: #f8f9fa;
            --bs-body-color: #212529;
            --card-bg: #ffffff;
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --form-min-height: 600px;
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e;
            --bs-body-color: #f8f9fa;
            --card-bg: #16213e;
            --primary-color: #5a67d8;
            --secondary-color: #a0aec0;
        }
        
        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .container {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 2rem 0;
        }
        
       .card {
    background-color: var(--card-bg);
    border: none;
    border-radius: 0.5rem;
    box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
    min-height: 450px; /* Reduced from 600px */
    padding: 1.5rem; /* Added padding to maintain internal spacing */
}

:root {
    /* ... other variables ... */
    --form-min-height: 450px; /* Reduced from 600px */
    /* ... other variables ... */
}
        
        .card-body {
            padding: 2.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.5rem 1.5rem;
            font-size: 1rem;
        }
        
        .btn-primary:hover {
            background-color: #3a56c7;
            border-color: #3a56c7;
        }
        
        .form-control, .form-select {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 0.35rem;
            padding: 0.75rem 1rem;
            font-size: 1rem;
        }
        
        .form-control:focus, .form-select:focus {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        
        .back-btn {
            transition: all 0.3s;
            padding: 0.5rem 1.5rem;
        }
        
        .back-btn:hover {
            transform: translateX(-3px);
        }
        
        .theme-toggle {
            transition: all 0.3s;
            padding: 0.5rem 1rem;
        }
        
        .theme-toggle:hover {
            transform: rotate(15deg);
        }
        
        .form-card {
            border-left: 0.25rem solid var(--primary-color) !important;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.75rem;
            font-size: 1rem;
        }
        
        .input-hint {
            font-size: 0.85rem;
            color: var(--secondary-color);
            margin-top: 0.5rem;
        }
        
        .input-group-text {
            background-color: rgba(78, 115, 223, 0.1);
            color: var(--primary-color);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        h2 {
            font-size: 2rem;
            margin: 0;
        }
        
        .row.g-3 > [class^="col-"] {
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-user-plus me-2"></i>Add New Student
                    </h2>
                    <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                        <i class="fas fa-moon"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm form-card" >
                    <div class="card-body" >
                        <form id="studentForm" action="AddStudentData" method="post">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="crn" class="form-label">CRN Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control" id="crn" name="crn" 
                                               placeholder="Enter CRN" required>
                                    </div>
                                    <div class="input-hint">Alphanumeric identifier (e.g., ABC123XYZ456)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Student Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               placeholder="Enter full name" required minlength="3">
                                    </div>
                                    <div class="input-hint">At least 3 characters</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="contact" class="form-label">Contact Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                        <input type="tel" class="form-control" id="contact" name="contact" 
                                               placeholder="Enter contact number" required maxlength="15">
                                    </div>
                                    <div class="input-hint">Phone number (e.g., 9876543210 or +919876543210)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="course" class="form-label">Course</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-graduation-cap"></i></span>
                                        <select class="form-select" id="course" name="course" required>
                                            <option value="" selected disabled>Select course</option>
                                            <option value="BCA">BCA</option>
                                            <option value="BBA">BBA</option>
                                            <option value="BTech">B. Tech</option>
                                            <option value="MCA">MCA</option>
                                            <option value="MBA">MBA</option>
                                            <option value="PTech">PolyTech</option>
                                        </select>
                                    </div>
                                    <div class="input-hint">Select the appropriate course</div>
                                </div>
                                
                                <div class="col-12 mt-4">
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-outline-secondary me-md-2">
                                            <i class="fas fa-undo me-2"></i>Reset Form
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Save Student
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize theme
            const themeToggle = document.getElementById('themeToggle');
            const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
            
            // Check for saved theme preference or use system preference
            if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && prefersDarkScheme.matches)) {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                document.documentElement.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
            
            // Theme toggle functionality
            themeToggle.addEventListener('click', function() {
                if (document.documentElement.getAttribute('data-bs-theme') === 'dark') {
                    document.documentElement.setAttribute('data-bs-theme', 'light');
                    themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
                    localStorage.setItem('theme', 'light');
                } else {
                    document.documentElement.setAttribute('data-bs-theme', 'dark');
                    themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
                    localStorage.setItem('theme', 'dark');
                }
            });
            
            // Form submission with validation
            $('#studentForm').submit(function(e) {
                e.preventDefault();
                
                // Get form values
                const crn = $('#crn').val().trim();
                const name = $('#name').val().trim();
                const contact = $('#contact').val().trim();
                const course = $('#course').val();
                
                // Validate CRN (alphanumeric, no length limit)
                if (!crn) {
                    showError('CRN Required', 'Please enter a CRN');
                    return;
                }
                
                // Validate Name (at least 3 characters)
                if (name.length < 3) {
                    showError('Invalid Name', 'Name must be at least 3 characters long');
                    return;
                }
                
                // Validate Contact (at least 10 characters)
                if (contact.length < 10) {
                    showError('Invalid Contact', 'Contact number must be at least 10 digits');
                    return;
                }
                
                // Validate Course (must be selected)
                if (!course) {
                    showError('Course Required', 'Please select a course from the dropdown');
                    return;
                }
                
                // Submit form via AJAX
                $.ajax({
                    url: 'AddStudentData',
                    type: 'POST',
                    data: $(this).serialize(),
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: response.message,
                                confirmButtonColor: 'var(--primary-color)',
                                willClose: () => {
                                    // Redirect to records page after success
                                    window.location.href = 'studentRecords.jsp';
                                }
                            });
                        } else {
                            showError('Operation Failed', response.message || 'Failed to add student');
                        }
                    },
                    error: function(xhr, status, error) {
                        showError('Server Error', 'Failed to communicate with server: ' + error);
                    }
                });
            });
            
            // Helper function to show error messages
            function showError(title, message) {
                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: message,
                    confirmButtonColor: 'var(--primary-color)'
                });
            }
        });
    </script>
</body>
</html>