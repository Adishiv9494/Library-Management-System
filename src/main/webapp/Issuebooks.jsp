<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Library Book Issue</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --card-bg-light: #ffffff;
            --card-bg-dark: #16213e;
            --text-light: #212529;
            --text-dark: #f8f9fa;
            --body-bg-light: #f8f9fa;
            --body-bg-dark: #1a1a2e;
        }

        [data-bs-theme="dark"] {
            --bs-body-bg: var(--body-bg-dark);
            --bs-body-color: var(--text-dark);
            --card-bg: var(--card-bg-dark);
            --primary-color: #5a67d8;
            --border-color: #495057;
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --bs-body-color: var(--text-light);
            --card-bg: var(--card-bg-light);
            --border-color: #dee2e6;
        }

        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
        }

        .card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 0.25rem 0.75rem rgba(0, 0, 0, 0.1);
        }

        .issue-details-container {
            border-left: 4px solid var(--primary-color);
            padding-left: 1.5rem;
        }

        .detail-section {
            margin-bottom: 1.5rem;
        }

        .detail-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        .detail-item {
            display: flex;
            margin-bottom: 0.5rem;
        }

        .detail-label {
            font-weight: 500;
            min-width: 120px;
            color: var(--secondary-color);
        }

        .detail-value {
            flex: 1;
        }

        .due-date-picker {
            max-width: 300px;
            margin-top: 1.5rem;
        }

        .theme-toggle-btn {
            transition: transform 0.3s;
        }
        .theme-toggle-btn:hover {
            transform: rotate(15deg);
        }
        
        .uppercase-input {
            text-transform: uppercase;
        }
        
        .loading-spinner {
            display: inline-block;
            width: 1rem;
            height: 1rem;
            border: 0.2em solid currentColor;
            border-right-color: transparent;
            border-radius: 50%;
            animation: spinner-border 0.75s linear infinite;
            vertical-align: -0.125em;
        }
        
        @keyframes spinner-border {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book-open me-2"></i>Book Issuance
                    </h2>
                    <button id="themeToggle" class="btn btn-outline-secondary theme-toggle-btn">
                        <i class="fas fa-moon"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <form id="issueForm">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Student CRN</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control uppercase-input" id="crn" required autocomplete="off">
                                    </div>
                                    <div class="invalid-feedback" id="crnError" style="display: none;"></div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Accession Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                        <input type="text" class="form-control" id="accessionNo" required>
                                    </div>
                                    <div class="invalid-feedback" id="accessionNoError" style="display: none;"></div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="button" id="resetBtn" class="btn btn-outline-secondary">
                                            <i class="fas fa-undo me-2"></i>Reset
                                        </button>
                                        <button type="button" id="viewBtn" class="btn btn-primary">
                                            <i class="fas fa-eye me-2"></i>View Details
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm mb-4" id="resultCard" style="display:none;">
                    <div class="card-body">
                        <h4 class="card-title mb-4" style="color: var(--primary-color);">
                            <i class="fas fa-info-circle me-2"></i>Issue Details
                        </h4>
                        
                        <div class="issue-details-container">
                            <!-- Student Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-user-graduate me-2"></i>Student Details
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Name:</span>
                                    <span class="detail-value" id="studentName"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Contact:</span>
                                    <span class="detail-value" id="studentContact"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Course:</span>
                                    <span class="detail-value" id="studentCourse"></span>
                                </div>
                            </div>
                            
                            <!-- Book Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-book me-2"></i>Book Details
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Title:</span>
                                    <span class="detail-value" id="bookTitle"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Author:</span>
                                    <span class="detail-value" id="bookAuthor"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Edition:</span>
                                    <span class="detail-value" id="bookEdition"></span>
                                </div>
                            </div>
                            
                            <!-- Due Date Section -->
                            <div class="due-date-picker" id="dueDateContainer" style="display:none;">
                                <label class="form-label">
                                    <i class="fas fa-calendar-day me-2"></i>Select Due Date
                                </label>
                                <input type="date" class="form-control" id="dueDate" required>
                                <div class="invalid-feedback" id="dueDateError" style="display: none;"></div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-4" id="issueBtnContainer" style="display:none;">
                            <button type="button" id="issueBtn" class="btn btn-success">
                                <i class="fas fa-check-circle me-2"></i>Issue Book
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
    $(document).ready(function() {
        // Theme Toggle Functionality
        function initTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            $('html').attr('data-bs-theme', savedTheme);
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(savedTheme === 'dark' ? 'fa-sun' : 'fa-moon');
        }

        $('#themeToggle').click(function() {
            const currentTheme = $('html').attr('data-bs-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            $('html').attr('data-bs-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(newTheme === 'dark' ? 'fa-sun' : 'fa-moon');
        });

        initTheme();

        // Force uppercase for CRN input
        $('#crn').on('input', function() {
            this.value = this.value.toUpperCase();
        });

        // View Details Button
        $('#viewBtn').click(function() {
            const crn = $('#crn').val().trim();
            const accessionNo = $('#accessionNo').val().trim();

            // Clear previous errors
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').hide();

            // Validate inputs
            let isValid = true;
            if (!crn) {
                $('#crn').addClass('is-invalid');
                $('#crnError').text('CRN is required').show();
                isValid = false;
            }
            if (!accessionNo) {
                $('#accessionNo').addClass('is-invalid');
                $('#accessionNoError').text('Accession number is required').show();
                isValid = false;
            }

            if (!isValid) {
                return;
            }

            // Show loading state
            const $viewBtn = $(this);
            $viewBtn.prop('disabled', true).html('<span class="loading-spinner me-2"></span>Loading...');

            $.ajax({
                url: 'FetchIssueData',
                type: 'POST',
                data: { 
                    crn: crn, 
                    accessionNo: accessionNo 
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        displayDetails(response);
                        $('#resultCard, #dueDateContainer, #issueBtnContainer').fadeIn();
                        
                        // Set minimum due date (tomorrow)
                        const tomorrow = new Date();
                        tomorrow.setDate(tomorrow.getDate() + 1);
                        $('#dueDate').attr('min', tomorrow.toISOString().split('T')[0]);
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: response.message,
                            confirmButtonColor: '#4e73df'
                        });
                        $('#resultCard').hide();
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to fetch details. Please check your connection and try again.',
                        confirmButtonColor: '#4e73df'
                    });
                },
                complete: function() {
                    $viewBtn.prop('disabled', false).html('<i class="fas fa-eye me-2"></i>View Details');
                }
            });
        });

        function displayDetails(data) {
            // Student Details
            $('#studentName').text(data.student.name || 'N/A');
            $('#studentContact').text(data.student.contact || 'N/A');
            $('#studentCourse').text(data.student.course || 'N/A');
            
            // Book Details
            $('#bookTitle').text(data.book.book_name || data.book.title || 'N/A');
            $('#bookAuthor').text(data.book.author || 'N/A');
            $('#bookEdition').text(data.book.edition || 'N/A');
            
            // Store data for issuing
            $('#resultCard').data('issueData', {
                crn: $('#crn').val(),
                name: data.student.name,
                contact: data.student.contact,
                course: data.student.course,
                accessionNo: data.book.accessionNo || data.book.accession_number,
                bookTitle: data.book.book_name || data.book.title,
                author: data.book.author,
                edition: data.book.edition
            });
        }

        // Issue Book Button
        $('#issueBtn').click(function() {
            const dueDate = $('#dueDate').val();
            
            // Clear previous errors
            $('#dueDate').removeClass('is-invalid');
            $('#dueDateError').hide();

            // Validate due date
            let isValid = true;
            if (!dueDate) {
                $('#dueDate').addClass('is-invalid');
                $('#dueDateError').text('Please select a due date').show();
                isValid = false;
            } else {
                // Validate date format
                const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                if (!dateRegex.test(dueDate)) {
                    $('#dueDate').addClass('is-invalid');
                    $('#dueDateError').text('Please use YYYY-MM-DD format').show();
                    isValid = false;
                } else {
                    // Validate date is in the future
                    const selectedDate = new Date(dueDate);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (selectedDate <= today) {
                        $('#dueDate').addClass('is-invalid');
                        $('#dueDateError').text('Due date must be after today').show();
                        isValid = false;
                    }
                }
            }

            if (!isValid) {
                return;
            }

            // Show loading state
            const $issueBtn = $(this);
            $issueBtn.prop('disabled', true).html('<span class="loading-spinner me-2"></span>Processing...');

            const issueData = $('#resultCard').data('issueData');
            issueData.dueDate = dueDate;

            $.ajax({
                url: 'IssueBook',
                type: 'POST',
                data: issueData,
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: response.message,
                            confirmButtonColor: '#4e73df',
                            showConfirmButton: true,
                            timer: 3000,
                            willClose: () => {
                                resetForm();
                            }
                        }).then((result) => {
                            if (result.isConfirmed || result.isDismissed) {
                                resetForm();
                            }
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: response.message,
                            confirmButtonColor: '#4e73df'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to issue book. Please check your connection and try again.',
                        confirmButtonColor: '#4e73df'
                    });
                },
                complete: function() {
                    $issueBtn.prop('disabled', false).html('<i class="fas fa-check-circle me-2"></i>Issue Book');
                }
            });
        });

        // Reset Button
        $('#resetBtn').click(function() {
            Swal.fire({
                title: 'Reset Form',
                text: 'Are you sure you want to clear all fields?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#4e73df',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, reset it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    resetForm();
                    Swal.fire(
                        'Reset!',
                        'The form has been reset.',
                        'success'
                    );
                }
            });
        });

        function resetForm() {
            // Reset form fields
            $('#issueForm')[0].reset();
            
            // Clear displayed data
            $('#studentName, #studentContact, #studentCourse, #bookTitle, #bookAuthor, #bookEdition').text('');
            
            // Hide result sections
            $('#resultCard, #dueDateContainer, #issueBtnContainer').hide();
            
            // Clear errors
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').hide();
            
            // Clear stored data
            $('#resultCard').removeData('issueData');
            
            // Reset date picker
            $('#dueDate').val('');
            
            // Focus on first input field
            $('#crn').focus();
        }

        // Input validation on blur
        $('#crn, #accessionNo').on('blur', function() {
            const $input = $(this);
            const $error = $input.next('.invalid-feedback');
            
            if (!$input.val().trim()) {
                $input.addClass('is-invalid');
                $error.text('This field is required').show();
            } else {
                $input.removeClass('is-invalid');
                $error.hide();
            }
        });

        // Date input validation
        $('#dueDate').on('change', function() {
            const $input = $(this);
            const $error = $('#dueDateError');
            const dueDate = $input.val();
            
            // Clear previous errors
            $input.removeClass('is-invalid');
            $error.hide();
            
            if (!dueDate) return;
            
            // Validate date format
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            if (!dateRegex.test(dueDate)) {
                $input.addClass('is-invalid');
                $error.text('Please use YYYY-MM-DD format').show();
                return;
            }
            
            // Validate date is in the future
            const selectedDate = new Date(dueDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate <= today) {
                $input.addClass('is-invalid');
                $error.text('Due date must be after today').show();
            }
        });
    });
    </script>
</body>
</html>