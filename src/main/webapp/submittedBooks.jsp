<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Return Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
        }
        
        [data-bs-theme="dark"] {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --body-bg: #1a1a2e;
            --card-bg: #16213e;
            --text-color: #f8f9fa;
            --border-color: #2c3e50;
        }
        
        body {
            background-color: var(--body-bg, #f8f9fc);
            color: var(--text-color, #212529);
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        .card {
            background-color: var(--card-bg, #ffffff);
            border-color: var(--border-color, #e3e6f0);
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }
        
        .form-control, .input-group-text {
            background-color: var(--card-bg, #ffffff);
            color: var(--text-color, #212529);
            border-color: var(--border-color, #ced4da);
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }
        
        .card-status-pending {
            border-left: 5px solid var(--info-color);
        }
        
        .card-status-ondue {
            border-left: 5px solid var(--success-color);
        }
        
        .card-status-overdue {
            border-left: 5px solid var(--warning-color);
        }
        
        .card-status-defaulter {
            border-left: 5px solid var(--danger-color);
        }
        
        .card-status-returned {
            border-left: 5px solid #858796;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: var(--info-color);
            color: white;
        }
        
        .status-ondue {
            background-color: var(--success-color);
            color: white;
        }
        
        .status-overdue {
            background-color: var(--warning-color);
            color: #000;
        }
        
        .status-defaulter {
            background-color: var(--danger-color);
            color: white;
        }
        
        .status-returned {
            background-color: #858796;
            color: white;
        }
        
        .btn-renew {
            background-color: var(--warning-color);
            color: #000;
            border: none;
        }
        
        .btn-renew:hover {
            background-color: #dda20a;
            color: #000;
        }
        
        .fine-amount {
            color: var(--danger-color);
            font-weight: bold;
        }
        
        .detail-section {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color, #e3e6f0);
        }
        
        .detail-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .detail-section-title {
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--primary-color);
        }
        
        .detail-item {
            display: flex;
            margin-bottom: 0.5rem;
        }
        
        .detail-label {
            font-weight: 600;
            min-width: 120px;
            color: var(--text-color, #5a5c69);
        }
        
        .detail-value {
            flex-grow: 1;
            color: var(--text-color, #5a5c69);
        }
        
        .theme-toggle-btn {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
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
                        <i class="fas fa-book-return me-2"></i>Book Return
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
                        <form id="returnForm">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Student CRN</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control" id="crn" required oninput="this.value = this.value.toUpperCase()">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Accession Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                        <input type="text" class="form-control" id="accessionNo" required>
                                    </div>
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
                            
                            <!-- Issue Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-calendar-alt me-2"></i>Issue Details
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Issue Date:</span>
                                    <span class="detail-value" id="issueDate"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Due Date:</span>
                                    <span class="detail-value" id="dueDate"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Status:</span>
                                    <span class="detail-value" id="status"></span>
                                </div>
                                <div class="detail-item" id="fineContainer" style="display:none;">
                                    <span class="detail-label">Fine Amount:</span>
                                    <span class="detail-value fine-amount" id="fineAmount"></span>
                                </div>
                                <div class="detail-item" id="daysOverdueContainer" style="display:none;">
                                    <span class="detail-label">Days Overdue:</span>
                                    <span class="detail-value" id="daysOverdue"></span>
                                </div>
                            </div>
                            
                            <!-- Renew Date Section -->
                            <div class="due-date-picker" id="renewDateContainer" style="display:none;">
                                <label class="form-label">
                                    <i class="fas fa-calendar-plus me-2"></i>Select New Due Date
                                </label>
                                <input type="date" class="form-control" id="renewDate" required>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2 mt-4" id="actionBtnContainer" style="display:none;">
                            <button type="button" id="renewBtn" class="btn btn-renew">
                                <i class="fas fa-sync-alt me-2"></i>Renew Book
                            </button>
                            <button type="button" id="returnBtn" class="btn btn-success">
                                <i class="fas fa-check-circle me-2"></i>Submit Book
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
        // Initialize theme
        function initTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            $('html').attr('data-bs-theme', savedTheme);
            updateThemeIcon(savedTheme);
        }

        function updateThemeIcon(theme) {
            const icon = $('#themeToggle i');
            icon.removeClass('fa-moon fa-sun');
            if (theme === 'dark') {
                icon.addClass('fa-sun');
            } else {
                icon.addClass('fa-moon');
            }
        }

        // Theme toggle
        $('#themeToggle').click(function() {
            const currentTheme = $('html').attr('data-bs-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            $('html').attr('data-bs-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        });

        initTheme();

        // Auto-uppercase CRN input
        $('#crn').on('input', function() {
            this.value = this.value.toUpperCase();
        });

        // View Details Button
        $('#viewBtn').click(function() {
            const crn = $('#crn').val().trim();
            const accessionNo = $('#accessionNo').val().trim();

            // Clear previous errors
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();

            // Validate inputs
            let isValid = true;
            if (!crn) {
                $('#crn').addClass('is-invalid');
                $('#crn').after('<div class="invalid-feedback">CRN is required</div>');
                isValid = false;
            }
            if (!accessionNo) {
                $('#accessionNo').addClass('is-invalid');
                $('#accessionNo').after('<div class="invalid-feedback">Accession number is required</div>');
                isValid = false;
            }

            if (!isValid) return;

            // Show loading state
            const $viewBtn = $(this);
            $viewBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Loading...');

            // AJAX request with error handling
            $.ajax({
                url: 'FetchReturnData',
                type: 'POST',
                data: { 
                    crn: crn, 
                    accessionNo: accessionNo 
                },
                dataType: 'json',
                timeout: 10000,
                success: function(response) {
                    if (response.success) {
                        displayDetails(response);
                        $('#resultCard, #actionBtnContainer').fadeIn();
                        
                        // Set card status based on book status
                        setCardStatus(response.data.status);
                        
                        // Handle buttons based on status
                        if (response.data.status === 'RETURNED') {
                            $('#renewBtn, #returnBtn').prop('disabled', true);
                            $('#renewDateContainer').hide();
                        } else if (response.data.status === 'DEFAULTER') {
                            $('#renewBtn, #returnBtn').prop('disabled', true);
                            $('#renewDateContainer').hide();
                            $('#fineContainer, #daysOverdueContainer').show();
                        } else if (response.data.status === 'OVERDUE') {
                            if (response.data.days_overdue > 14) {
                                $('#renewBtn').prop('disabled', true);
                            } else {
                                $('#renewBtn').prop('disabled', false);
                            }
                            $('#returnBtn').prop('disabled', false);
                            $('#fineContainer, #daysOverdueContainer').show();
                            $('#renewDateContainer').hide();
                        } else if (response.data.status === 'ON DUE') {
                            $('#renewBtn').prop('disabled', false);
                            $('#returnBtn').prop('disabled', false);
                            $('#fineContainer, #daysOverdueContainer').hide();
                            $('#renewDateContainer').hide();
                        } else {
                            $('#renewBtn, #returnBtn').prop('disabled', false);
                            const tomorrow = new Date();
                            tomorrow.setDate(tomorrow.getDate() + 1);
                            $('#renewDate').attr('min', tomorrow.toISOString().split('T')[0]);
                        }
                    } else {
                        showError('Error', response.message || 'No record found');
                        $('#resultCard').hide();
                    }
                },
                error: function(xhr, status, error) {
                    let errorMsg = 'Failed to fetch details';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg += ': ' + xhr.responseJSON.message;
                    } else if (status === 'timeout') {
                        errorMsg = 'Request timed out. Please try again.';
                    } else if (error) {
                        errorMsg += ': ' + error;
                    }
                    showError('Error', errorMsg);
                },
                complete: function() {
                    $viewBtn.prop('disabled', false).html('<i class="fas fa-eye me-2"></i>View Details');
                }
            });
        });

        function setCardStatus(status) {
            // Remove all status classes first
            $('#resultCard').removeClass('card-status-pending card-status-ondue card-status-overdue card-status-defaulter card-status-returned');
            
            // Add the appropriate status class
            switch(status) {
                case 'PENDING':
                    $('#resultCard').addClass('card-status-pending');
                    break;
                case 'ON DUE':
                    $('#resultCard').addClass('card-status-ondue');
                    break;
                case 'OVERDUE':
                    $('#resultCard').addClass('card-status-overdue');
                    break;
                case 'DEFAULTER':
                    $('#resultCard').addClass('card-status-defaulter');
                    break;
                case 'RETURNED':
                    $('#resultCard').addClass('card-status-returned');
                    break;
                default:
                    $('#resultCard').addClass('card-status-pending');
            }
        }

        function displayDetails(data) {
            // Student Details
            $('#studentName').text(data.data.student_name || 'N/A');
            $('#studentContact').text(data.data.contact || 'N/A');
            $('#studentCourse').text(data.data.course || 'N/A');
            
            // Book Details
            $('#bookTitle').text(data.data.book_title || 'N/A');
            $('#bookAuthor').text(data.data.author || 'N/A');
            $('#bookEdition').text(data.data.edition || 'N/A');
            
            // Issue Details
            $('#issueDate').text(formatDate(data.data.issue_date) || 'N/A');
            $('#dueDate').text(formatDate(data.data.due_date) || 'N/A');
            
            // Status with badge
            const status = data.data.status || 'PENDING';
            let statusClass = 'status-pending';
            let statusText = status;
            
            switch(status) {
                case 'ON DUE':
                    statusClass = 'status-ondue';
                    break;
                case 'OVERDUE':
                    statusClass = 'status-overdue';
                    break;
                case 'DEFAULTER':
                    statusClass = 'status-defaulter';
                    break;
                case 'RETURNED':
                    statusClass = 'status-returned';
                    break;
                default:
                    statusClass = 'status-pending';
            }
            
            $('#status').html(`<span class="status-badge ${statusClass}">${statusText}</span>`);
            
            // Fine amount and days overdue
            if (data.data.fine_amount > 0) {
                $('#fineAmount').text('₹' + data.data.fine_amount.toFixed(2));
                $('#fineContainer').show();
            } else {
                $('#fineContainer').hide();
            }
            
            if (data.data.days_overdue > 0) {
                $('#daysOverdue').text(data.data.days_overdue + ' days');
                $('#daysOverdueContainer').show();
            } else {
                $('#daysOverdueContainer').hide();
            }
            
            // Store data for return/renew
            $('#resultCard').data('issueData', {
                issueId: data.data.issue_id,
                crn: data.data.crn,
                accessionNo: data.data.accession_number,
                currentDueDate: data.data.due_date,
                fineAmount: data.data.fine_amount || 0,
                daysOverdue: data.data.days_overdue || 0,
                status: status
            });
        }
        
        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleDateString('en-IN');
        }

        function showError(title, message) {
            Swal.fire({
                icon: 'error',
                title: title,
                text: message,
                confirmButtonColor: '#4e73df'
            });
        }

        // Renew Book Button
        $('#renewBtn').click(function() {
            const issueData = $('#resultCard').data('issueData');
            
            // Show renew date container if not already visible
            if ($('#renewDateContainer').is(':hidden')) {
                $('#renewDateContainer').fadeIn();
                return;
            }
            
            const renewDate = $('#renewDate').val();
            
            // Clear previous errors
            $('#renewDate').removeClass('is-invalid');
            $('.invalid-feedback').remove();

            // Validate renew date
            let isValid = true;
            if (!renewDate) {
                $('#renewDate').addClass('is-invalid');
                $('#renewDate').after('<div class="invalid-feedback">Please select a new due date</div>');
                isValid = false;
            } else {
                const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                if (!dateRegex.test(renewDate)) {
                    $('#renewDate').addClass('is-invalid');
                    $('#renewDate').after('<div class="invalid-feedback">Please use YYYY-MM-DD format</div>');
                    isValid = false;
                } else {
                    const selectedDate = new Date(renewDate);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (selectedDate <= today) {
                        $('#renewDate').addClass('is-invalid');
                        $('#renewDate').after('<div class="invalid-feedback">New due date must be after today</div>');
                        isValid = false;
                    }
                }
            }

            if (!isValid) return;

            const $renewBtn = $(this);
            $renewBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

            issueData.newDueDate = renewDate;

            $.ajax({
                url: 'RenewBook',
                type: 'POST',
                data: issueData,
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: response.message,
                            confirmButtonColor: '#4e73df'
                        }).then(() => {
                            // Refresh the details
                            $('#viewBtn').click();
                            $('#renewDateContainer').hide();
                        });
                    } else {
                        showError('Error', response.message);
                    }
                },
                error: function(xhr, status, error) {
                    showError('Error', 'Failed to renew book: ' + (xhr.responseJSON?.message || error));
                },
                complete: function() {
                    $renewBtn.prop('disabled', false).html('<i class="fas fa-sync-alt me-2"></i>Renew Book');
                }
            });
        });

        // Return Book Button
        $('#returnBtn').click(function() {
            Swal.fire({
                title: 'Confirm Return',
                text: 'Are you sure you want to mark this book as returned?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#4e73df',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, return it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    const $returnBtn = $(this);
                    $returnBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

                    const issueData = $('#resultCard').data('issueData');

                    $.ajax({
                        url: 'ReturnBook',
                        type: 'POST',
                        data: issueData,
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success!',
                                    text: response.message,
                                    confirmButtonColor: '#4e73df'
                                }).then(() => {
                                    // Refresh the form
                                    resetForm();
                                });
                            } else {
                                showError('Error', response.message);
                            }
                        },
                        error: function(xhr, status, error) {
                            showError('Error', 'Failed to return book: ' + (xhr.responseJSON?.message || error));
                        },
                        complete: function() {
                            $returnBtn.prop('disabled', false).html('<i class="fas fa-check-circle me-2"></i>Submit Book');
                        }
                    });
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
                    Swal.fire('Reset!', 'The form has been reset.', 'success');
                }
            });
        });

        function resetForm() {
            $('#returnForm')[0].reset();
            $('#studentName, #studentContact, #studentCourse, #bookTitle, #bookAuthor, #bookEdition, #issueDate, #dueDate, #status, #fineAmount, #daysOverdue').text('');
            $('#resultCard, #renewDateContainer, #actionBtnContainer, #fineContainer, #daysOverdueContainer').hide();
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            $('#resultCard').removeData('issueData');
            $('#renewDate').val('');
            $('#crn').focus();
            $('#resultCard').removeClass('card-status-pending card-status-ondue card-status-overdue card-status-defaulter card-status-returned');
        }

        // Input validation
        $('#crn, #accessionNo').on('blur', function() {
            const $input = $(this);
            if (!$input.val().trim()) {
                $input.addClass('is-invalid');
                if (!$input.next('.invalid-feedback').length) {
                    $input.after('<div class="invalid-feedback">This field is required</div>');
                }
            } else {
                $input.removeClass('is-invalid');
                $input.next('.invalid-feedback').remove();
            }
        });

        $('#renewDate').on('change', function() {
            const $input = $(this);
            const renewDate = $input.val();
            
            $input.removeClass('is-invalid');
            $input.next('.invalid-feedback').remove();
            
            if (!renewDate) return;
            
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            if (!dateRegex.test(renewDate)) {
                $input.addClass('is-invalid');
                $input.after('<div class="invalid-feedback">Please use YYYY-MM-DD format</div>');
                return;
            }
            
            const selectedDate = new Date(renewDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate <= today) {
                $input.addClass('is-invalid');
                $input.after('<div class="invalid-feedback">New due date must be after today</div>');
            }
        });
    });
    </script>
</body>
</html>